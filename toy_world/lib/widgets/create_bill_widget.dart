import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  String? exchangeWith;
  double? value;
  String groupChatId;

  CreateBillWidget(
      {required this.buyerId,
      required this.tradingPostId,
      required this.toyOfSellerName,
      required this.groupChatId,
      this.exchangeWith,
      this.value});

  @override
  State<CreateBillWidget> createState() => _CreateBillWidgetState();
}

class _CreateBillWidgetState extends State<CreateBillWidget> {
  String? toyOfBuyerName;
  bool? isExchangeMoney = false;
  double? exchangeValue;
  String _token = "";
  BillCreated? billCreated;
  final oCcy = NumberFormat("#,##0", "vi-VN");

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
    if (widget.exchangeWith == "Money" || widget.exchangeWith == "money") {
      isExchangeMoney = true;
      toyOfBuyerName = null;
      exchangeValue = widget.value;
    } else {
      toyOfBuyerName = widget.exchangeWith;
      exchangeValue = null;
    }
    CreateNewBill newBill = CreateNewBill();
    billCreated = await newBill.createNewBill(
        token: _token,
        buyerId: widget.buyerId,
        tradingPostId: widget.tradingPostId,
        toyOfSellerName: widget.toyOfSellerName,
        toyOfBuyerName: toyOfBuyerName,
        isExchangeByMoney: isExchangeMoney,
        exchangeValue: exchangeValue);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AlertDialog(
        title: const Text(
          "New Bill",
          style: TextStyle(color: Color(0xffDB36A4), fontSize: 26),
          textAlign: TextAlign.center,
        ),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buildItemInfo("Seller's toy:", value: widget.toyOfSellerName),
                      _buildItemInfo("Exchange with:", value: widget.exchangeWith),
                      widget.exchangeWith == "Money" || widget.exchangeWith == "money"
                      ? _buildItemInfo("Value:", value: oCcy.format(widget.value).toString() + " VND")
                      : const SizedBox.shrink(),
                      const SizedBox(height: 10,),
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
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ))),
                          child: const Text(
                            "Send",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                          onPressed: () async {
                            await checkCreateBill();
                            if (billCreated != null) {
                              await updateDataFirestore(
                                  FirestoreConstants
                                      .pathTradingMessageCollection,
                                  widget.groupChatId,
                                  {
                                    FirestoreConstants.billId:
                                        billCreated?.billId
                                  });
                              Navigator.of(context).pop();
                              loadingSuccess(status: "Create bill success!!!");
                            } else {
                              loadingFail(status: "Create Bill Failed");
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
      ),
    );
  }

  Widget _buildItemInfo(String label, {value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(child: Text("$value")),
        ],
      ),
    );
  }
}
