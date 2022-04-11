import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:toy_world/apis/posts/post_new_trading_post.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/utils/helpers.dart';

class CreateTradingPostWidget extends StatefulWidget {
  int role;
  String token;
  int groupID;

  CreateTradingPostWidget({
    required this.role,
    required this.token,
    required this.groupID,
  });

  @override
  State<CreateTradingPostWidget> createState() =>
      _CreateTradingPostWidgetState();
}

class _CreateTradingPostWidgetState extends State<CreateTradingPostWidget> {
  final _formKey = GlobalKey<FormState>();
  List<Asset> imagesPicker = <Asset>[];
  String _error = 'No Error Dectected';

  String? title;
  String? toyName;
  String? content;
  String? address;
  String? exchange;
  double? exchangeValue;
  String? phone;
  bool? isExchangeMoney = false;

  checkCreateTradingPost({List<String>? imagesLink}) async {
    NewTradingPost newTradingPost = NewTradingPost();
    var status = await newTradingPost.newTradingPost(
        token: widget.token,
        groupId: widget.groupID,
        title: title,
        toyName: toyName,
        address: address,
        exchange: exchange,
        value: exchangeValue,
        phone: phone,
        content: content,
        imgLink: imagesLink);
    return status;
  }

  Future<void>

  loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 100,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffDB36A4),
          title: const Text(
            "New Trading Post",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Post content",
                        style:
                            TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
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
                            vertical: 15.0, horizontal: 10.0),
                        fillColor: Colors.grey[200],
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          content = value.trim();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Content",
                        hintText: "Enter content of your trading post",
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        fillColor: Colors.grey[200],
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
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Trading Info",
                        style:
                            TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      maxLines: 2,
                      minLines: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          toyName = value.trim();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Toy's name",
                        hintText: "Your toy name",
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        fillColor: Colors.grey[200],
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
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Align(
                      child: Text(
                        "Exchange with: ",
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 24.0,
                                    width: 24.0,
                                    child: Checkbox(
                                        value: !isExchangeMoney!,
                                        onChanged: (value) {
                                          setState(() {
                                            isExchangeMoney = !value!;
                                            exchangeValue = null;
                                          });
                                        })),
                                // You can play with the width to adjust your
                                // desired spacing
                                const SizedBox(width: 10.0),
                                const Text("Toy")
                              ]),
                        ),
                        Flexible(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 24.0,
                                    width: 24.0,
                                    child: Checkbox(
                                        value: isExchangeMoney,
                                        onChanged: (value) {
                                          setState(() {
                                            isExchangeMoney = value;
                                            exchange = "money";
                                          });
                                        })),
                                // You can play with the width to adjust your
                                // desired spacing
                                const SizedBox(width: 10.0),
                                const Text("Money")
                              ]),
                        ),
                      ],
                    ),
                  ),
                  isExchangeMoney == false
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            maxLines: 1,
                            onChanged: (value) {
                              setState(() {
                                exchange = value.trim();
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Toy want to exchange",
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
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
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              if (double.tryParse(value) != null) {
                                setState(() {
                                  exchangeValue = double.parse(value);
                                });
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Value",
                              hintText: "Input amount of money",
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
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
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Photo: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 150,
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
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
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Contact Info",
                        style:
                            TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
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
                          address = value.trim();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Address",
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        fillColor: Colors.grey[200],
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          phone = value.trim();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        hintText: "Enter your phone to contact",
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        fillColor: Colors.grey[200],
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
                                    MaterialStateProperty.all(Colors.redAccent),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ))),
                            child: const Text(
                              "Cancel",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16.0),
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
                                    MaterialStateProperty.all(Colors.green),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ))),
                            child: const Text(
                              "Create",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16.0),
                            ),
                            onPressed: () async {
                              try {
                                List<String> imageUrls;
                                imageUrls = await uploadImages(
                                    imagesPicker, "TradingPost");
                                if (_formKey.currentState!.validate()) {
                                  if (await checkCreateTradingPost(
                                          imagesLink: imageUrls) ==
                                      200) {
                                    setState(() {
                                      imagesPicker.clear();
                                    });
                                    Navigator.of(context).pop();
                                    loadingSuccess(status: "Create success!!!");
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
    );
  }

  Widget buildGridViewImagePicker() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
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
