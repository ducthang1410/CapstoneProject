import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:toy_world/apis/posts/post_new_contest.dart';
import 'package:toy_world/components/component.dart';
import 'package:intl/intl.dart';
import 'package:toy_world/utils/helpers.dart';

class NewContestPage extends StatefulWidget {
  int role;
  String token;
  int groupId;

  NewContestPage(
      {required this.role, required this.token, required this.groupId});

  @override
  State<NewContestPage> createState() => _NewContestPageState();
}

class _NewContestPageState extends State<NewContestPage> {
  final _formKey = GlobalKey<FormState>();
  List<Asset> imagesPicker = <Asset>[];
  String _error = 'No Error Dectected';

  String? title;
  String? description;
  String? slogan;
  String? rule;
  DateTime startRegistration = DateTime.now();
  DateTime endRegistration = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String? typeName;

  checkCreateContest({String? imageLink}) async {
    NewContest newContest = NewContest();
    var status = await newContest.newContest(
        token: widget.token,
        groupId: widget.groupId,
        title: title,
        description: description,
        coverImage: imageLink,
        slogan: slogan,
        rule: rule,
        startRegistration: DateFormat("yyyy-MM-ddTHH:mm:ssZ").format(startRegistration),
        endRegistration: DateFormat("yyyy-MM-ddTHH:mm:ssZ").format(endRegistration),
        startDate: DateFormat("yyyy-MM-ddTHH:mm:ssZ").format(startDate),
        endDate: DateFormat("yyyy-MM-ddTHH:mm:ssZ").format(endDate),
        typeName: typeName);
    return status;
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: imagesPicker,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Select Photo",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      imagesPicker = resultList;
      _error = error;
    });
  }

  void _selectDate(BuildContext context, selectedDate, initialDate) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: initialDate,
        lastDate: DateTime(DateTime.now().year + 5));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Column(
          children: [
            sideAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                            "New Contest",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
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
                            maxLines: 5,
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
                            maxLines: 20,
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
                            maxLines: 20,
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
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Start Registration: ",
                                style: TextStyle(
                                    color: Color(0xff302B63),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey.shade300),
                                  child: Center(
                                    child: Text(
                                      DateFormat('dd/MM/yyyy kk:mm')
                                          .format(startRegistration),
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              IconButton(
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate:
                                            DateTime(DateTime.now().year + 5));
                                    if (picked != null &&
                                        picked != startRegistration) {
                                      setState(() {
                                        startRegistration = picked;
                                        endRegistration = startRegistration;
                                        startDate = endRegistration;
                                        endDate = startDate;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.calendar_today_sharp)),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'End Registration: ',
                                style: TextStyle(
                                    color: Color(0xff302B63),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey.shade300),
                                  child: Center(
                                    child: Text(
                                      DateFormat('dd/MM/yyyy kk:mm')
                                          .format(endRegistration),
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              IconButton(
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                        context: context,
                                        initialDate: startRegistration,
                                        firstDate: startRegistration,
                                        lastDate:
                                            DateTime(DateTime.now().year + 5));
                                    if (picked != null &&
                                        picked != endRegistration) {
                                      setState(() {
                                        endRegistration = picked;
                                        startDate = endRegistration;
                                        endDate = startDate;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.calendar_today_sharp)),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Start Date",
                                style: TextStyle(
                                    color: Color(0xff302B63),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey.shade300),
                                  child: Center(
                                    child: Text(
                                      DateFormat('dd/MM/yyyy kk:mm')
                                          .format(startDate),
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              IconButton(
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                        context: context,
                                        initialDate: endRegistration,
                                        firstDate: endRegistration,
                                        lastDate:
                                            DateTime(DateTime.now().year + 5));
                                    if (picked != null && picked != startDate) {
                                      setState(() {
                                        startDate = picked;
                                        endDate = startDate;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.calendar_today_sharp)),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "End Date: ",
                                style: TextStyle(
                                    color: Color(0xff302B63),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey.shade300),
                                  child: Center(
                                    child: Text(
                                      DateFormat('dd/MM/yyyy kk:mm')
                                          .format(endDate),
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              IconButton(
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                        context: context,
                                        initialDate: startDate,
                                        firstDate: startDate,
                                        lastDate:
                                            DateTime(DateTime.now().year + 5));
                                    if (picked != null && picked != endDate) {
                                      setState(() {
                                        endDate = picked;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.calendar_today_sharp)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Contest's Image: ",
                                style: TextStyle(
                                    color: Color(0xff302B63),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: 150,
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color(0xffDB36A4)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ))),
                                    child: const Text(
                                      "Choose",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                    onPressed: loadAssets),
                              ),
                            ],
                          ),
                        ),
                        imagesPicker.isNotEmpty
                            ? buildGridViewImagePicker()
                            : const SizedBox.shrink(),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 130,
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.redAccent),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ))),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: 130,
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ))),
                                  child: const Text(
                                    "Create",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                  onPressed: () async {
                                    try {
                                      List<String> imageUrls;
                                      imageUrls = await uploadImages(
                                          imagesPicker, "Contest");
                                      if (_formKey.currentState!.validate()) {
                                        if (await checkCreateContest(
                                                imageLink: imageUrls[0]) ==
                                            200) {
                                          setState(() {
                                            imagesPicker.clear();
                                          });
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
                                  }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget selectDate(String label, selectedDate, initialDate) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: const TextStyle(
                    color: Color(0xff302B63),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey.shade300),
                  child: Center(
                    child: Text(
                      DateFormat('dd/MM/yyyy kk:mm').format(selectedDate),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              IconButton(
                  onPressed: () =>
                      _selectDate(context, selectedDate, initialDate),
                  icon: const Icon(Icons.calendar_today_sharp)),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildGridViewImagePicker() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 1,
      children: List.generate(imagesPicker.length, (index) {
        Asset asset = imagesPicker[index];
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              ),
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  color: const Color.fromRGBO(255, 255, 244, 0.2),
                  child: IconButton(
                    onPressed: () {
                      imagesPicker.removeAt(index);
                      setState(() {});
                    },
                    icon: const Icon(Icons.delete),
                    color: Colors.black87,
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
