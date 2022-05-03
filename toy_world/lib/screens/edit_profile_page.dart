import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:toy_world/apis/gets/get_account_info.dart';
import 'package:toy_world/apis/puts/put_edit_profile.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_account_info.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  int role;
  String token;
  int accountId;

  EditProfilePage(
      {required this.role, required this.token, required this.accountId});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  AccountInfo? _accountInfo;
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";

  String? fullName;
  String? phone;
  String? biography;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  String url = "";
  List<String> genderList = ["Male", "Female", "Others"];
  String selectedGender = "Male";

  @override
  void initState() {
    // TODO: implement initState
    getAccountInfo();
    super.initState();
  }

  getAccountInfo() async {
    loadingLoad(status: "Loading...");
    AccountInfoData accountInfoData = AccountInfoData();
    _accountInfo = await accountInfoData.getAccountInfo(
        token: widget.token, accountId: widget.accountId);
    url = _accountInfo?.avatar ?? _avatar;
    selectedGender = _accountInfo?.gender ?? "Male";
    phone = _accountInfo?.phone ?? "";
    EasyLoading.dismiss();
    if (!mounted) return;
    setState(() {});
    return _accountInfo;
  }

  checkEditProfile({fullName, phone, avatar, biography, gender}) async {
    EditProfile profile = EditProfile();
    var status = await profile.editProfile(
      token: widget.token,
      accountId: widget.accountId,
      name: fullName,
      phone: phone,
      avatar: avatar,
      biography: biography,
      gender: gender,
    );
    return status;
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    loadingLoad(status: "Loading");
    if (_photo == null) return;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      Reference ref =
          FirebaseStorage.instance.ref().child("Avatar").child(fileName);
      UploadTask uploadTask = ref.putFile(_photo!);
      url = await (await uploadTask).ref.getDownloadURL();
      setState(() {});
      EasyLoading.dismiss();
      return url;
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffDB36A4),
        elevation: 1,
        title: const Text("Edit Profile"),
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
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(url != ""
                                ? url
                                : _accountInfo?.avatar ?? _avatar),
                          )),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: const Color(0xffDB36A4),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              imgFromGallery();
                            },
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              buildTextField(
                "Full Name",
                _accountInfo?.name ?? "Name",
                false,
                maxLength: 50,
                onChanged: (value) {
                  fullName = value.trim();
                  setState(() {});
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Gender",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 14),
                          )),
                    ),
                    Flexible(
                      child: SizedBox(
                        height: 60.0,
                        width: 120.0,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                    width: 2, color: Color(0xffDB36A4))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                    width: 2, color: Color(0xffDB36A4))),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGender = newValue!;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'field required' : null,
                          value: selectedGender,
                          elevation: 16,
                          items: genderList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Center(child: Text(value)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              buildTextField(
                "Phone",
                _accountInfo?.phone ?? "",
                true,
                onChanged: (value) {
                  phone = value.trim();
                  setState(() {});
                },
              ),
              buildTextField(
                "Biography",
                _accountInfo?.biography ?? "Not updated",
                false,
                maxLength: 200,
                onChanged: (value) {
                  biography = value.trim();
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    color: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      if (phone?.length != 10) {
                        loadingFail(
                            status:
                                "Your phone number isn't correct structure");
                        return;
                      }
                      loadingLoad(status: "Loading...");
                      if (await checkEditProfile(
                              avatar: url,
                              fullName:
                                  fullName ?? _accountInfo?.name ?? "Name",
                              phone: phone ?? _accountInfo?.phone ?? "",
                              biography: biography ??
                                  _accountInfo?.biography ??
                                  "Not updated",
                              gender: selectedGender) ==
                          200) {
                        loadingSuccess(status: "Edit Success");
                        Navigator.of(context).pop();
                      } else {
                        loadingFail(status: "Edit Failed");
                      }
                    },
                    color: const Color(0xffDB36A4),
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder, bool isDigitInput,
      {maxLength, onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: TextField(
        minLines: 1,
        maxLines: 5,
        maxLength: maxLength,
        keyboardType: isDigitInput == true ? TextInputType.number : null,
        inputFormatters: isDigitInput == true
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ]
            : null,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            labelStyle: const TextStyle(
              fontSize: 18,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            )),
        onChanged: onChanged,
      ),
    );
  }
}
