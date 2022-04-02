import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:toy_world/apis/gets/get_bill_detail.dart';
import 'package:toy_world/apis/posts/post_rate_seller.dart';
import 'package:toy_world/apis/puts/put_close_cancel_bill.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_bill.dart';
import 'package:toy_world/models/model_message_chat.dart';

import 'package:toy_world/screens/full_photo_page.dart';
import 'package:toy_world/utils/firestore_constants.dart';
import 'package:toy_world/utils/firestore_service.dart';
import 'package:toy_world/utils/helpers.dart';
import 'package:intl/intl.dart';
import 'package:toy_world/widgets/create_bill_widget.dart';
import 'package:toy_world/widgets/get_bill_widget.dart';

class TradingChatPage extends StatefulWidget {
  TradingChatPage({Key? key, required this.arguments}) : super(key: key);

  TradingChatPageArguments arguments;

  @override
  State<TradingChatPage> createState() => _TradingChatPageState();
}

class _TradingChatPageState extends State<TradingChatPage> {
  List<QueryDocumentSnapshot> listMessage = [];
  List<Asset> imagesPicker = <Asset>[];
  int _limit = 20;
  int _limitIncrement = 20;
  String groupChatId = "";
  Bill? bill;
  int? _billId;
  bool? isBillCreated;
  double rating = 0;
  String contentRating = "";

  bool isLoading = false;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    readLocal();
    listScrollController.addListener(_scrollListener);
    super.initState();
  }

  getData() async {
    BillDetail billDetail = BillDetail();
    bill = await billDetail.getBillDetail(
        token: widget.arguments.token, billId: _billId);
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
    return bill;
  }

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange &&
        _limit <= listMessage.length) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  readLocal() {
    int? currentUserId = widget.arguments.currentUserId;
    int? peerId = widget.arguments.peerId;
    int? tradingPostId = widget.arguments.tradingPostId;
    if (currentUserId! < peerId!) {
      groupChatId = '$currentUserId-$peerId-$tradingPostId';
    } else {
      groupChatId = '$peerId-$currentUserId-$tradingPostId';
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get(FirestoreConstants.fromId) ==
                widget.arguments.currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get(FirestoreConstants.fromId) !=
                widget.arguments.currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);

    return Future.value(false);
  }

  Future<void> loadAssets() async {
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
    });
  }

  uploadImageMessage(List<Asset> images, String directory) async {
    final imageUrls = <String>[];
    try {
      for (var image in images) {
        final url = await postImage(image, directory);
        imageUrls.add(url);
        setState(() {
          isLoading = false;
          onSendMessage(url, TypeMessage.image);
        });
      }
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }

    return imageUrls;
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      sendTradingMessage(content, type, groupChatId,
          widget.arguments.currentUserId, widget.arguments.peerId);
      listScrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: const Color(0xffaeaeae));
    }
  }

  checkRatingSeller() async {
    RateSeller rateSeller = RateSeller();
    int status = await rateSeller.rateSeller(
        token: widget.arguments.token,
        billId: _billId,
        numOfStar: rating.toInt(),
        content: contentRating);
    if (status == 200) {
      Navigator.of(context).pop();
      loadingSuccess(status: "Thanks for your rating !!!");
    } else {
      loadingFail(status: "Rating failed :((((");
    }
  }

  closeCancelBill({choice}) async {
    CloseCancelBill bill = CloseCancelBill();
    int status = await bill.closeOrCancelBill(
        token: widget.arguments.token, billId: _billId, choice: choice);
    if (status == 200) {
      setState(() async {
        if (choice == 3) {
          await updateDataFirestore(
              FirestoreConstants.pathTradingMessageCollection,
              groupChatId,
              {FirestoreConstants.isBillCreated: false});
          Navigator.of(context).pop();
          loadingSuccess(status: "Cancel Trading Success");
        } else if (choice == 2) {
          Navigator.of(context).pop();
          loadingSuccess(status: "Confirm Trading Success");
        }
      });
    } else {
      loadingFail(status: "Failed !!!");
    }
    setState(() {});
  }

  void showConfirmTrading(Size size) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text(
              "Confirm Trading",
              style: TextStyle(color: Color(0xffDB36A4), fontSize: 26),
              textAlign: TextAlign.center,
            ),
            content: Stack(
              overflow: Overflow.visible,
              children: [
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
                  width: size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Have you delivered your toy to the buyer and success your trading?",
                        style: TextStyle(fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: SizedBox(
                                height: 60,
                                child: Padding(
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
                                      "Cancel Trading",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                    onPressed: () {
                                      closeCancelBill(choice: 3);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: SizedBox(
                                height: 60,
                                child: Padding(
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
                                      "Trading Success",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    onPressed: () {
                                      closeCancelBill(choice: 2);
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ));

  void showRating(Size size) => showDialog(
        context: context,
        builder: (context) => SingleChildScrollView(
          child: AlertDialog(
            title: const Text(
              "Rate Seller",
              style: TextStyle(color: Color(0xffDB36A4), fontSize: 26),
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              width: size.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildRating(),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Flexible(
                    child: TextField(
                      maxLines: 5,
                      onChanged: (value) {
                        setState(() {
                          contentRating = value.trim();
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Enter your rating comment",
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.redAccent,
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        Flexible(
                          child: Container(
                            width: 130,
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.lightGreen,
                                  ),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                              child: const Text(
                                "OK",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                              onPressed: () {
                                checkRatingSeller();
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
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffDB36A4),
        title: Text(
          widget.arguments.title ?? "Trading",
          maxLines: 1,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: getTradingMessageData(groupChatId),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              _billId = snapshot.data!['billId'];
              isBillCreated = snapshot.data!['isBillCreated'];
              return WillPopScope(
                child: Column(
                  children: [
                    isBillCreated == false
                        ? widget.arguments.currentUserId ==
                                widget.arguments.sellerId
                            ? buildCreateBill()
                            : _billId != null
                                ? buildGetBill()
                                : const SizedBox.shrink()
                        : buildFinishBill(),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              // List of messages
                              buildListMessage(),

                              // Input content
                              buildInput(),
                            ],
                          ),

                          // Loading
                          buildLoading()
                        ],
                      ),
                    ),
                  ],
                ),
                onWillPop: onBackPress,
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget buildCreateBill() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      height: 50,
      color: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Create Bill for Trading",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CreateBillWidget(
                      buyerId: widget.arguments.buyerId,
                      tradingPostId: widget.arguments.tradingPostId,
                      toyOfSellerName: widget.arguments.toyName,
                      groupChatId: groupChatId,
                    );
                  });
            },
            child: const Text("Create"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                const Color(0xffDB36A4),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildGetBill() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      height: 50,
      color: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Get Owner's bill",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              await getData();
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return GetBillWidget(
                      billId: bill!.id,
                      toyOfSellerName: bill!.toyOfSellerName,
                      toyOfBuyerName: bill!.toyOfBuyerName,
                      isExchangeByMoney: bill!.isExchangeByMoney,
                      exchangeValue: bill!.exchangeValue,
                      sellerName: bill!.sellerName,
                      buyerName: bill!.buyerName,
                      status: bill!.status,
                      createTime: bill!.createTime,
                      groupChatId: groupChatId,
                      isBillFinished: false,
                    );
                  });
            },
            child: const Text("Get Bill"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                const Color(0xffDB36A4),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildFinishBill() {
    var size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      height: 60,
      color: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.arguments.currentUserId == widget.arguments.sellerId
              ? Flexible(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        showConfirmTrading(size);
                      },
                      child: const Text(
                        "Confirm trading",
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              : Flexible(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        showRating(size);
                      },
                      child: const Text(
                        "Rate Seller",
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
          const SizedBox(
            width: 40,
          ),
          Flexible(
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await getData();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return GetBillWidget(
                          billId: bill!.id,
                          toyOfSellerName: bill!.toyOfSellerName,
                          toyOfBuyerName: bill!.toyOfBuyerName,
                          isExchangeByMoney: bill!.isExchangeByMoney,
                          exchangeValue: bill!.exchangeValue,
                          sellerName: bill!.sellerName,
                          buyerName: bill!.buyerName,
                          status: bill!.status,
                          createTime: bill!.createTime,
                          groupChatId: groupChatId,
                          isBillFinished: true,
                        );
                      });
                },
                child: const Text(
                  "Bill Details",
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRating() => RatingBar.builder(
      minRating: 1,
      maxRating: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
      updateOnDrag: true,
      onRatingUpdate: (rating) {
        setState(() {
          this.rating = rating;
        });
      });

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xffDB36A4),
                ),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: const Icon(Icons.image),
                onPressed: () async {
                  await loadAssets();
                  if (imagesPicker.isNotEmpty) {
                    setState(() {
                      isLoading = true;
                    });
                    await uploadImageMessage(imagesPicker, "Chat");
                  }
                },
                color: const Color(0xffDB36A4),
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: TextField(
              onSubmitted: (value) {
                onSendMessage(textEditingController.text, TypeMessage.text);
              },
              style: const TextStyle(fontSize: 15),
              controller: textEditingController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Color(0xffaeaeae)),
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () =>
                    onSendMessage(textEditingController.text, TypeMessage.text),
                color: const Color(0xffDB36A4),
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xffE8E8E8), width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: getTradingChatStream(groupChatId, _limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage = snapshot.data!.docs;
                  if (listMessage.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) =>
                          buildItem(index, snapshot.data?.docs[index]),
                      itemCount: snapshot.data?.docs.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  } else {
                    return const Center(child: Text("No message here yet..."));
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffDB36A4),
                    ),
                  );
                }
              },
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Color(0xffDB36A4),
              ),
            ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      MessageChat messageChat = MessageChat.fromDocument(document);
      if (messageChat.fromId == widget.arguments.currentUserId) {
        // Right (my message)
        return Container(
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  messageChat.type == TypeMessage.text
                      // Text
                      ? Container(
                          child: Text(
                            messageChat.content,
                            style: const TextStyle(color: Color(0xff203152)),
                          ),
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          constraints: const BoxConstraints(maxWidth: 300),
                          decoration: BoxDecoration(
                              color: const Color(0xffE8E8E8),
                              borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.only(right: 10),
                        )
                      : messageChat.type == TypeMessage.image
                          // Image
                          ? Container(
                              child: OutlinedButton(
                                child: Material(
                                  child: Image.network(
                                    messageChat.content,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xffE8E8E8),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        width: 200,
                                        height: 200,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: const Color(0xffDB36A4),
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, object, stackTrace) {
                                      return Material(
                                        child: Image.asset(
                                          'assets/images/img_not_available.jpeg',
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                      );
                                    },
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                onPressed: () {
                                  onImageClicked(context, messageChat.content);
                                },
                                style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.all(0))),
                              ),
                              margin: EdgeInsets.only(
                                  bottom: isLastMessageRight(index) ? 20 : 10,
                                  right: 10),
                            )
                          // Sticker
                          : Container(
                              child: Image.asset(
                                'images/${messageChat.content}.gif',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              margin: EdgeInsets.only(
                                  bottom: isLastMessageRight(index) ? 20 : 10,
                                  right: 10),
                            ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),

              // Time
              isLastMessageRight(index)
                  ? Container(
                      child: Text(
                        DateFormat('dd MMM kk:mm')
                            .format(messageChat.timestamp.toDate()),
                        style: const TextStyle(
                            color: Color(0xffaeaeae),
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                      margin:
                          const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                    )
                  : const SizedBox.shrink()
            ],
            crossAxisAlignment: CrossAxisAlignment.end,
          ),
          margin: const EdgeInsets.only(bottom: 10),
        );
      } else {
        // Left (peer message)
        return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  messageChat.type == TypeMessage.text
                      ? Container(
                          child: Text(
                            messageChat.content,
                            style: const TextStyle(color: Colors.white),
                          ),
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          constraints: const BoxConstraints(maxWidth: 300),
                          decoration: BoxDecoration(
                              color: const Color(0xffDB36A4),
                              borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.only(left: 10),
                        )
                      : messageChat.type == TypeMessage.image
                          ? Container(
                              child: TextButton(
                                child: Material(
                                  child: Image.network(
                                    messageChat.content,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xffE8E8E8),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        width: 200,
                                        height: 200,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: const Color(0xffDB36A4),
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, object, stackTrace) =>
                                            Material(
                                      child: Image.asset(
                                        'assets/images/img_not_available.jpeg',
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullPhotoPage(
                                          url: messageChat.content),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.all(0))),
                              ),
                              margin: const EdgeInsets.only(left: 10),
                            )
                          : Container(
                              child: Image.asset(
                                'images/${messageChat.content}.gif',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              margin: EdgeInsets.only(
                                  bottom: isLastMessageRight(index) ? 20 : 10,
                                  right: 10),
                            ),
                ],
              ),

              // Time
              isLastMessageLeft(index)
                  ? Container(
                      child: Text(
                        DateFormat('dd MMM kk:mm')
                            .format(messageChat.timestamp.toDate()),
                        style: const TextStyle(
                            color: Color(0xffaeaeae),
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                      margin:
                          const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    )
                  : const SizedBox.shrink()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: const EdgeInsets.only(bottom: 10),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}

class TradingChatPageArguments {
  String token;
  int currentUserId;
  int? peerId;
  int? sellerId;
  int? buyerId;
  String? title;
  String? toyName;
  int? tradingPostId;

  TradingChatPageArguments({
    required this.token,
    required this.currentUserId,
    required this.peerId,
    required this.sellerId,
    required this.buyerId,
    required this.title,
    required this.toyName,
    required this.tradingPostId,
  });
}

class TypeMessage {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
}
