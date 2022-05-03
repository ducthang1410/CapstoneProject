import 'package:flutter/material.dart';
import 'package:toy_world/apis/puts/put_change_password.dart';
import 'package:toy_world/apis/puts/put_new_password.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/screens/login_page.dart';
import 'package:toy_world/utils/google_login.dart';

class ChangePasswordPage extends StatefulWidget {
  int role;
  String token;
  bool isHasPassword;

  ChangePasswordPage(
      {required this.role, required this.token, required this.isHasPassword});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String oldPassword = "";
  String newPassword = "";
  String renewPassword = "";
  bool _isObscureOldPassword = true;
  bool _isObscureNewPassword = true;
  bool _isObscureReNewPassword = true;

  checkChangePassword({oldPassword, newPassword}) async {
    ChangePassword changePassword = ChangePassword();
    var status = await changePassword.changePassword(
        token: widget.token,
        oldPassword: oldPassword,
        newPassword: newPassword);
    return status;
  }

  checkNewPassword({newPassword}) async {
    NewPassword password = NewPassword();
    var status = await password.newPassword(
        token: widget.token, newPassword: newPassword);
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffDB36A4),
        elevation: 1,
        title: Text(
            widget.isHasPassword == true ? "Change Password" : "New Password"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, top: 25, right: 20),
        child: ListView(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    widget.isHasPassword == true
                        ? Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Old Password: ",
                                      style: TextStyle(
                                          color: Color(0xff302B63),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: TextFormField(
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter old password';
                                    } if (value.length < 8 || value.length > 26){
                                      return "Password must between 8-26 characters";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    oldPassword = value.trim();
                                    setState(() {});
                                  },
                                  obscureText: _isObscureOldPassword,
                                  decoration: InputDecoration(
                                    labelText: "Old Password",
                                    filled: true,
                                    fillColor: Colors.grey[300],
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Color(0xffDB36A4),
                                    ),
                                    suffixIcon: IconButton(
                                        icon: Icon(
                                          _isObscureOldPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isObscureOldPassword =
                                                !_isObscureOldPassword;
                                          });
                                        }),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xffDB36A4)),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "New Password: ",
                            style: TextStyle(
                                color: Color(0xff302B63),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter new password';
                          } if (value.length < 8 || value.length > 26){
                            return "Password must between 8-26 characters";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          newPassword = value.trim();
                          setState(() {});
                        },
                        obscureText: _isObscureNewPassword,
                        decoration: InputDecoration(
                          labelText: "New Password",
                          filled: true,
                          fillColor: Colors.grey[300],
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color(0xffDB36A4),
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(
                                _isObscureNewPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscureNewPassword =
                                      !_isObscureNewPassword;
                                });
                              }),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xffDB36A4)),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Re-type Password: ",
                            style: TextStyle(
                                color: Color(0xff302B63),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter re-type password';
                          } if (renewPassword != newPassword) {
                            return "Re-type password don't match new password";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          renewPassword = value.trim();
                          setState(() {});
                        },
                        obscureText: _isObscureReNewPassword,
                        decoration: InputDecoration(
                          labelText: "Re-type Password",
                          filled: true,
                          fillColor: Colors.grey[300],
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color(0xffDB36A4),
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(
                                _isObscureReNewPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscureReNewPassword =
                                      !_isObscureReNewPassword;
                                });
                              }),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xffDB36A4)),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 120,
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xffDB36A4)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ))),
                          child: const Text(
                            "Save",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              loadingLoad(status: "Loading...");
                              if (renewPassword != newPassword) {
                                loadingFail(
                                    status:
                                        "Re-type password don't match new password");
                                return;
                              }
                              if (widget.isHasPassword == true) {
                                int status = await checkChangePassword(
                                    oldPassword: oldPassword,
                                    newPassword: newPassword);
                                if (status == 200) {
                                  loadingSuccess(status: "Change Success");
                                  signOut(context);
                                } else if (status == 400) {
                                  loadingFail(
                                      status: "Old password is wrong!!!");
                                } else {
                                  loadingFail(status: "Change Failed");
                                }
                              } else {
                                int status = await checkNewPassword(
                                    newPassword: newPassword);
                                if (status == 200) {
                                  loadingSuccess(
                                      status: "New Password Success");
                                  signOut(context);
                                } else {
                                  loadingFail(status: "New Password Failed");
                                }
                              }
                            }
                          }),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
