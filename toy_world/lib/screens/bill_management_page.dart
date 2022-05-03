import 'package:flutter/material.dart';
import 'package:toy_world/apis/gets/get_bill_by_status.dart';
import 'package:toy_world/models/model_bill_status.dart';
import 'package:toy_world/models/model_choice.dart';
import 'package:intl/intl.dart';
import 'package:toy_world/screens/expand_photo_page.dart';
import 'package:toy_world/screens/trading_post_detail_page.dart';
import 'package:toy_world/widgets/get_bill_widget.dart';

class BillManagementPage extends StatefulWidget {
  int role;
  String token;

  BillManagementPage({required this.role, required this.token});

  @override
  State<BillManagementPage> createState() => _BillManagementPageState();
}

class _BillManagementPageState extends State<BillManagementPage> {
  BillsStatus? data;
  List<BillStatus>? bills;
  int _limit = 10;
  final int _limitIncrement = 10;
  final ScrollController listScrollController = ScrollController();

  List<Choice> items = <Choice>[
    Choice(id: 0, name: "Draft"),
    Choice(id: 1, name: "Delivery"),
    Choice(id: 2, name: "Closed"),
    Choice(id: 3, name: "Cancel"),
  ];
  Choice? selectedItem = Choice(id: 0, name: "Draft");

  @override
  void initState() {
    // TODO: implement initState
    listScrollController.addListener(scrollListener);
    if (!mounted) return;
    super.initState();
  }

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  getData() async {
    BillByStatus billByStatus = BillByStatus();
    data = await billByStatus.getBillByStatus(
        token: widget.token, status: selectedItem!.id, size: _limit);
    if (data == null) return List.empty();
    bills = data!.data!.cast<BillStatus>();
    setState(() {});
    return bills;
  }

  void showBill({BillStatus? bill, formatDate}) {
    BuildContext dialogContext;
    showDialog(
        context: context,
        builder: (context) {
          dialogContext = context;
          return Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                insetPadding: const EdgeInsets.symmetric(
                    vertical: 100.0, horizontal: 20.0),
                title: const Text(
                  "Bill Detail",
                  style: TextStyle(color: Color(0xffDB36A4), fontSize: 26),
                  textAlign: TextAlign.center,
                ),
                content: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      right: -40.0,
                      top: -95.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.pop(dialogContext);
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
                        _buildItemInfo("Sender Name:", value: bill?.senderName),
                        _buildItemInfo("Receiver Name:",
                            value: bill?.receiverName),
                        _buildItemInfo("Sender's toy:", value: bill?.senderToy),
                        bill?.receiverToy != null || bill?.receiverToy != ""
                            ? _buildItemInfo("Receiver's toy:",
                                value: bill?.receiverToy ?? "")
                            : const SizedBox.shrink(),
                        _buildItemInfo("Date:", value: formatDate),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 130,
                              height: 60,
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
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                  onPressed: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => ExpandPhotoPage(
                                                role: widget.role,
                                                token: widget.token,
                                                images: bill?.images ?? [],
                                              )))),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 130,
                              height: 60,
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
                                    "View Trading",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TradingPostDetailPage(
                                                role: widget.role,
                                                token: widget.token,
                                                tradingPostID: bill?.idPost,
                                              )))),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5.0, right: 10.0),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: SizedBox(
              height: 60.0,
              width: 150.0,
              child: DropdownButtonFormField<Choice>(
                isExpanded: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(width: 3, color: Color(0xffDB36A4))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(width: 3, color: Color(0xffDB36A4))),
                ),
                onChanged: (Choice? newValue) {
                  setState(() {
                    selectedItem = newValue;
                  });
                },
                value: items[0],
                elevation: 16,
                items: items.map<DropdownMenuItem<Choice>>((Choice value) {
                  return DropdownMenuItem<Choice>(
                    value: value,
                    child: Center(child: Text(value.name)),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: FutureBuilder(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (bills?.length != null && bills!.isNotEmpty) {
                        return ListView.builder(
                            controller: listScrollController,
                            padding: EdgeInsets.zero,
                            itemCount: bills?.length,
                            itemBuilder: (context, index) {
                              return _bill(
                                bill: bills?[index],
                              );
                            });
                      } else {
                        return const Center(
                          child: Text("No bill recently"),
                        );
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bill({BillStatus? bill}) {
    String formatDate = DateFormat('dd MMM yyyy kk:mm')
        .format(bill?.updateTime ?? DateTime.now());
    return GestureDetector(
      onTap: () => showBill(bill: bill, formatDate: formatDate),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.grey.shade300),
            bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Sender Name: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  bill?.senderName ?? "Name",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Receiver Name: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  bill?.receiverName ?? "Name",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Send Date: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  formatDate,
                  style: const TextStyle(fontSize: 16),
                ),
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
            width: 130,
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
