
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/apis/posts/post_bill.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_bill_created.dart';
import 'package:toy_world/utils/firestore_constants.dart';
import 'package:toy_world/utils/firestore_service.dart';

class CreateBillWidget extends StatefulWidget {
  int? buyerId;
  int? tradingPostId;
  String? toyOfSellerName;
  String groupChatId;

  CreateBillWidget({
    required this.buyerId,
    required this.tradingPostId,
    required this.toyOfSellerName,
    required this.groupChatId,
  });

  @override
  State<CreateBillWidget> createState() => _CreateBillWidgetState();
}

class _CreateBillWidgetState extends State<CreateBillWidget> {
  final _formKey = GlobalKey<FormState>();

  String? toyOfSellerName;
  String? toyOfBuyerName;
  bool? isExchangeMoney = false;
  double? exchangeValue;
  String _token = "";
  BillCreated? billCreated;

  @override
  void initState() {
    // TODO: implement initState
    _loadCounter();
    super.initState();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = (prefs.getString('token') ?? "");
    });
  }

  checkCreateBill() async {
    if (isExchangeMoney == true) {
      toyOfBuyerName = null;
    } else {
      exchangeValue = null;
    }
    CreateNewBill newBill = CreateNewBill();
    billCreated = await newBill.createNewBill(
        token: _token,
        buyerId: widget.buyerId,
        tradingPostId: widget.tradingPostId,
        toyOfSellerName: toyOfSellerName,
        toyOfBuyerName: toyOfBuyerName,
        isExchangeByMoney: isExchangeMoney,
        exchangeValue: exchangeValue);
  }

  @override
  Widget build(BuildContext context) {
    toyOfSellerName = widget.toyOfSellerName;
    var size = MediaQuery.of(context).size;
    return AlertDialog(
      title: const Text("New Bill", style: TextStyle(color: Color(0xffDB36A4), fontSize: 26), textAlign: TextAlign.center,),
      content: SingleChildScrollView(
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              right: -40.0,
              top: -95.0,
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const CircleAvatar(
                  child: Icon(Icons.close),
                  backgroundColor: Colors.redAccent,
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.7,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        maxLines: 1,
                        initialValue: widget.toyOfSellerName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            toyOfSellerName = value.trim();
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Toy's name",
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
                    const Align(
                      child: Text("Exchange with: "),
                      alignment: Alignment.centerLeft,
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
                                  toyOfBuyerName = value.trim();
                                });
                              },
                              decoration: InputDecoration(
                                labelText: "Toy want to exchange",
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                fillColor: Colors.grey[200],
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
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                fillColor: Colors.grey[200],
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
                    Container(
                      width: 100,
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xffDB36A4),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                        child: const Text(
                          "Send",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await checkCreateBill();
                            if (billCreated != null) {
                              await updateDataFirestore(
                                  FirestoreConstants
                                      .pathTradingMessageCollection,
                                  widget.groupChatId,
                                  {FirestoreConstants.billId: billCreated?.billId});
                              Navigator.of(context).pop();
                              loadingSuccess(status: "Create bill success!!!");
                            } else {
                              loadingFail(status: "Create Bill Failed");
                            }
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
