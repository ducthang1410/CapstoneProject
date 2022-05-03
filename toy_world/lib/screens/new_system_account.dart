import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:toy_world/apis/posts/post_new_account.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/screens/login_page.dart';

class CreateNewAccountPage extends StatefulWidget {
  const CreateNewAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateNewAccountPage> createState() => _CreateNewAccountPageState();
}

class _CreateNewAccountPageState extends State<CreateNewAccountPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscurePassword = true;
  bool _isObscureRePassword = true;
  String _name = "";
  String _email = "";
  String _password = "";
  String _rePassword = "";

  checkSignUp({name, email, password}) async {
    NewAccount newAccount = NewAccount();
    var status = await newAccount.newAccount(
        name: name, email: email, password: password);
    return status;
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
        width: size.width * 0.85,
        height: 650,
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
            frmSignUp(),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 30),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Already have an account?",
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
                    alignment: Alignment.centerRight, child: signInButton()))
          ],
        ),
      ),
    );
  }

  Widget frmSignUp() {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.75,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              maxLines: 1,
              maxLength: 50,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
              onChanged: (value) {
                _name = value.trim();
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: "Name",
                filled: true,
                fillColor: Colors.grey[300],
                prefixIcon: const Icon(Icons.person, color: Color(0xffDB36A4)),
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
              height: 10,
            ),
            TextFormField(
              maxLines: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                } if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                  return "Your mail is not correct structure";
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
              height: 10,
            ),
            TextFormField(
              maxLines: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                } if (value.length < 8 || value.length > 26){
                  return "Password must between 8-26 characters";
                }
                return null;
              },
              onChanged: (value) {
                _password = value.trim();
                setState(() {});
              },
              obscureText: _isObscurePassword,
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
                      _isObscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscurePassword = !_isObscurePassword;
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
              height: 10,
            ),
            TextFormField(
              maxLines: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter re-password';
                } if (_rePassword != _password) {
                  return "Re-password don't match password";
                }
                return null;
              },
              onChanged: (value) {
                _rePassword = value.trim();
                setState(() {});
              },
              obscureText: _isObscureRePassword,
              decoration: InputDecoration(
                labelText: "Re-Password",
                filled: true,
                fillColor: Colors.grey[300],
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Color(0xffDB36A4),
                ),
                suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureRePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureRePassword = !_isObscureRePassword;
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
                        loadingLoad(status: "Signing Up...");
                        int status = await checkSignUp(
                            name: _name, email: _email, password: _password);
                        if (status == 200) {
                          EasyLoading.dismiss();
                          loadingSuccess(status: "Sign Up Success");
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                              (route) => false);
                        } else if(status == 400) {
                          loadingFail(status: "Email Existed");
                        }
                        else {
                          loadingFail(status: "Sign Up Failed");
                        }
                      } catch (e) {
                        loadingFail(status: "Sign Up Failed !!! \n $e");
                      }
                    }
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget signInButton() {
    return Container(
      width: 130,
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
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false);
          },
          child: const Text(
            "Sign In",
            style: TextStyle(fontSize: 18, color: Colors.white),
          )),
    );
  }
}
