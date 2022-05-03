import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sign_button/sign_button.dart';
import 'package:toy_world/apis/posts/post_login.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/screens/new_system_account.dart';
import 'package:toy_world/screens/welcome_page.dart';
import 'package:toy_world/utils/google_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  int _roleValue = 0;
  String _token = "";
  String _email = "";
  String _password = "";
  bool _isHasWishlist = false;

  @override
  void initState() {
    // TODO: implement initState
    _loadCounter();
    super.initState();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _roleValue = (prefs.getInt('role') ?? 0);
      _token = (prefs.getString('token') ?? "");
      _isHasWishlist = (prefs.getBool("isHasWishlist") ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xffDB36A4),
          Color(0xffF7FF00),
        ],
      )),
      child: content(),
    );
  }

  Widget content() {
    var size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        // width: 350,
        // height: 550,
        width: size.width * 0.85,
        height: 600,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 1,
              offset: Offset(0, 0), // Shadow position
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/Logo_Word_Black.png",
              width: 230,
            ),
            const SizedBox(
              height: 20,
            ),
            frmLogin(),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "--- Or ---",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 5,
            ),
            googleLogin(),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.only(left: 30),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Don't have an account?",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.only(right: 30, bottom: 20),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: createNewAccount()))
          ],
        ),
      ),
    );
  }

  Widget frmLogin() {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.75,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              maxLines: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                }
                return null;
              },
              onChanged: (value) {
                _email = value.trim();
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: "Email",
                filled: true,
                fillColor: Colors.grey[300],
                prefixIcon: const Icon(Icons.mail, color: Color(0xffDB36A4)),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffDB36A4)),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              maxLines: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
              onChanged: (value) {
                _password = value.trim();
                setState(() {});
              },
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: "Password",
                filled: true,
                fillColor: Colors.grey[300],
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Color(0xffDB36A4),
                ),
                suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    }),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffDB36A4)),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 140,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xffDB36A4),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 4,
                    offset: Offset(0, 0), // Shadow position
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: FlatButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        loadingLoad(status: "Signing In...");
                        if (await checkLoginSystemAccount(
                                email: _email, password: _password) ==
                            200) {
                          await _loadCounter();
                          if (_roleValue == 0) {
                            loadingFail(
                                status:
                                    "Admin is not available in this app !!!");
                            return;
                          }
                          EasyLoading.dismiss();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => WelcomePage(
                                        role: _roleValue,
                                        token: _token,
                                        isHasWishlist: _isHasWishlist,
                                      )),
                              (route) => false);
                        } else {
                          loadingFail(status: "Email or Password is not correct");
                        }
                      } catch (e) {
                        loadingFail(status: "Sign in Failed !!! \n $e");
                      }
                    }
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

  checkLogin({firebaseToken}) async {
    PostLogin postLogin = PostLogin();
    var status = await postLogin.login(firebaseToken: firebaseToken);
    return status;
  }

  checkLoginSystemAccount({email, password}) async {
    await Firebase.initializeApp();
    // await FirebaseAuth.instance.signInAnonymously();
    PostLoginSystemAccount postLogin = PostLoginSystemAccount();
    var status = await postLogin.login(email: email, password: password);
    return status;
  }

  Widget googleLogin() {
    return SignInButton(
        buttonType: ButtonType.googleDark,
        buttonSize: ButtonSize.large, // small(default), medium, large
        onPressed: () async {
          try {
            loadingLoad(status: "Signing In...");
            String? fbToken = await signIn();
            if (await checkLogin(firebaseToken: fbToken) == 200) {
              await _loadCounter();
              if (_roleValue == 0) {
                loadingFail(status: "Admin is not available in this app !!!");
                return;
              }
              EasyLoading.dismiss();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => WelcomePage(
                            role: _roleValue,
                            token: _token,
                            isHasWishlist: _isHasWishlist,
                          )),
                  (route) => false);
            } else {
              loadingFail(
                  status:
                      "Sign in Failed - ${await checkLogin(firebaseToken: fbToken)}");
            }
          } catch (e) {
            loadingFail(status: "Sign in Failed !!! \n $e");
          }
        });
  }

  Widget createNewAccount() {
    return Container(
      width: 140,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topLeft,
          colors: [
            Color(0xffDB36A4),
            Color(0xffF7FF00),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 4,
            offset: Offset(0, 0), // Shadow position
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: FlatButton(
          onPressed: () {
            EasyLoading.dismiss();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const CreateNewAccountPage()),
                (route) => false);
          },
          child: const Text(
            "Create new",
            style: TextStyle(fontSize: 18, color: Colors.white),
          )),
    );
  }
}
