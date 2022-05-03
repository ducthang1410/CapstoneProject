import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:toy_world/apis/gets/get_group_list.dart';
import 'package:toy_world/apis/posts/post_new_proposal.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_group.dart';

class NewProposalPage extends StatefulWidget {
  int role;
  String token;

  NewProposalPage({required this.role, required this.token});

  @override
  State<NewProposalPage> createState() => _NewProposalPageState();
}

class _NewProposalPageState extends State<NewProposalPage> {
  final _formKey = GlobalKey<FormState>();

  int? groupId;
  String? title;
  String? slogan;
  String? reason;
  String? description;
  String? rule;

  List<Group>? data = [];
  Group? selectedItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    loadingLoad(status: "Loading...");
    GroupList groups = GroupList();
    data = await groups.getListGroup(token: widget.token);
    EasyLoading.dismiss();
    if (data == null) return List.empty();
    setState(() {});
    return data;
  }

  checkCreateProposal() async {
    NewProposal newProposal = NewProposal();
    var status = await newProposal.newProposal(
        token: widget.token,
        groupId: selectedItem!.id,
        title: title,
        description: description,
        reason: reason,
        slogan: slogan,
        rule: rule);
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffDB36A4),
          elevation: 1,
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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "New Proposal",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 30.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Group",
                              style: TextStyle(
                                  color: Color(0xff302B63),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: 60.0,
                          width: 200.0,
                          child: DropdownButtonFormField<Group>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                      width: 3, color: Color(0xffDB36A4))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                      width: 3, color: Color(0xffDB36A4))),
                            ),
                            hint: const Text(
                              'Choose group',
                            ),
                            onChanged: (Group? newValue) {
                              setState(() {
                                selectedItem = newValue;
                              });
                            },
                            validator: (value) =>
                                value == null ? 'field required' : null,
                            value: selectedItem,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            items: data
                                ?.map<DropdownMenuItem<Group>>((Group value) {
                              return DropdownMenuItem<Group>(
                                value: value,
                                child: Center(child: Text(value.name ?? "")),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Title",
                          style: TextStyle(
                              color: Color(0xff302B63),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 3,
                      maxLength: 100,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } else if(value.length < 6){
                          return "Title must have at least 6 characters";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          title = value.trim();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Title",
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        fillColor: Colors.grey[200],
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
                          "Reason",
                          style: TextStyle(
                              color: Color(0xff302B63),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      maxLength: 200,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          reason = value.trim();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Reason",
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        fillColor: Colors.grey[200],
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
                          "Slogan: ",
                          style: TextStyle(
                              color: Color(0xff302B63),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 3,
                      maxLength: 100,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          slogan = value.trim();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Slogan",
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        fillColor: Colors.grey[200],
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
                          "Description: ",
                          style: TextStyle(
                              color: Color(0xff302B63),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      minLines: 3,
                      maxLines: 10,
                      maxLength: 500,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          description = value.trim();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Description",
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        fillColor: Colors.grey[200],
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
                          "Rule: ",
                          style: TextStyle(
                              color: Color(0xff302B63),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      minLines: 3,
                      maxLines: 10,
                      maxLength: 500,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          rule = value.trim();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Rule",
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        fillColor: Colors.grey[200],
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Container(
                            width: 130,
                            height: 50,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.grey.shade300,
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 16.0),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: 130,
                            height: 50,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    const Color(0xffDB36A4),
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                              onPressed: () async {
                                try {
                                  if (_formKey.currentState!.validate()) {
                                    loadingLoad(status: "Loading...");
                                    if (await checkCreateProposal() == 200) {
                                      setState(() {});
                                      Navigator.of(context).pop();
                                      loadingSuccess(
                                          status: "Create success!!!");
                                    } else {
                                      loadingFail(status: "Create Failed");
                                    }
                                  }
                                } catch (e) {
                                  loadingFail(
                                      status: "Create Failed !!! \n $e");
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
