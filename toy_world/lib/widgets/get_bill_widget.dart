import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:toy_world/apis/puts/put_accept_deny_bill.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_image_post.dart';
import 'package:toy_world/screens/expand_photo_page.dart';
import 'package:toy_world/utils/firestore_constants.dart';
import 'package:toy_world/utils/firestore_service.dart';

class GetBillWidget extends StatefulWidget {
  int? billId;
  String? toyOfSellerName;
  String? toyOfBuyerName;
  bool? isExchangeByMoney;
  double? exchangeValue;
  String? sellerName;
  String? buyerName;
  int? status;
  DateTime? updateTime;
  String groupChatId;
  List<ImagePost> images;
  bool isBillFinished;

  GetBillWidget(
      {required this.billId,
      required this.toyOfSellerName,
      this.toyOfBuyerName,
      required this.isExchangeByMoney,
      this.exchangeValue,
      required this.sellerName,
      required this.buyerName,
      required this.status,
      required this.updateTime,
      required this.groupChatId,
        required this.images,
      required this.isBillFinished});

  @override
  State<GetBillWidget> createState() => _GetBillWidgetState();
}

class _GetBillWidgetState extends State<GetBillWidget> {
  int role = 2;
  String _token = "";
  @override
  void initState() {
    // TODO: implement initState
    _loadCounter();
    super.initState();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = (prefs.getInt('role') ?? 0);
      _token = (prefs.getString('token') ?? "");
    });
  }

  acceptDenyBill({choice}) async {
    AcceptDenyBill bill = AcceptDenyBill();
    int status = await bill.acceptOrDenyBill(
        token: _token, billId: widget.billId, choice: choice);
    if (status == 200) {
      setState(() async {
        if (choice == 0) {
          await updateDataFirestore(
              FirestoreConstants.pathTradingMessageCollection,
              widget.groupChatId,
              {FirestoreConstants.billId: widget.billId});
          Navigator.of(context).pop();
          loadingSuccess(status: "Deny Success");
        } else if (choice == 1) {
          await updateDataFirestore(
              FirestoreConstants.pathTradingMessageCollection,
              widget.groupChatId,
              {FirestoreConstants.billId: widget.billId});
          await updateDataFirestore(
              FirestoreConstants.pathTradingMessageCollection,
              widget.groupChatId,
              {FirestoreConstants.isBillCreated: true});
          Navigator.of(context).pop();
          loadingSuccess(status: "Accept Success");
        }
      });
    } else {
      loadingFail(status: "Failed !!!");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String formatDate =
        DateFormat('dd MMM yyyy kk:mm').format(widget.updateTime!);
    return AlertDialog(
      title: const Text("Bill Detail", style: TextStyle(color: Color(0xffDB36A4), fontSize: 26), textAlign: TextAlign.center,),
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildItemInfo("Seller's name:", value: widget.sellerName),
                _buildItemInfo("Buyer's name:", value: widget.buyerName),
                _buildItemInfo("Seller's toy:", value: widget.toyOfSellerName),
                _buildItemInfo("Exchange with:",
                    value: widget.isExchangeByMoney == true ? "Money" : "Toy"),
                widget.isExchangeByMoney == true
                    ? _buildItemInfo("Value:", value: widget.exchangeValue)
                    : _buildItemInfo("Buyer's toy:",
                        value: widget.toyOfBuyerName ?? ""),
                _buildItemInfo("Date:", value: formatDate),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(
                          const Color(0xffDB36A4),
                        ),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10.0),
                            ))),
                    child: const Text(
                      "View Image Of Toy",
                      style: TextStyle(
                          color: Colors.white, fontSize: 16.0),
                    ),
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ExpandPhotoPage(
                          role: role,
                          token: _token,
                          images: widget.images,
                        )))),
                  ),
                widget.isBillFinished == false
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                width: 130,
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Colors.redAccent,
                                      ),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ))),
                                  child: const Text(
                                    "Deny",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                  onPressed: () {
                                    acceptDenyBill(choice: 0);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: Container(
                                width: 130,
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Colors.lightGreen,
                                      ),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ))),
                                  child: const Text(
                                    "Accept",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                  onPressed: () {
                                    acceptDenyBill(choice: 1);
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItemInfo(String label, {value}) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.3,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold),),
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
