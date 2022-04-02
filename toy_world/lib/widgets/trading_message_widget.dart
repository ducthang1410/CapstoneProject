import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/models/model_trading_message.dart';
import 'package:toy_world/screens/trading_chat_page.dart';
import 'package:toy_world/utils/debouncer.dart';
import 'package:toy_world/utils/firestore_constants.dart';
import 'package:toy_world/utils/firestore_service.dart';
import 'package:toy_world/utils/utilities.dart';

class TradingMessageWidget extends StatefulWidget {
  const TradingMessageWidget({Key? key}) : super(key: key);

  @override
  State<TradingMessageWidget> createState() => _TradingMessageWidgetState();
}

class _TradingMessageWidgetState extends State<TradingMessageWidget> {
  int _currentUserId = 0;
  String _token = "";
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";

  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  final int _limitIncrement = 20;
  String _textSearch = "";

  Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  StreamController<bool> btnClearController = StreamController<bool>();
  TextEditingController searchBarTec = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _loadCounter();
    listScrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    btnClearController.close();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = (prefs.getInt('accountId') ?? 0);
      _token = (prefs.getString('token') ?? "");
      _avatar = (prefs.getString('avatar') ?? "");
    });
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSearchBar(),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: getTradingMessageStream(
                FirestoreConstants.pathTradingMessageCollection, _limit),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if ((snapshot.data?.docs.length ?? 0) > 0) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) =>
                        buildItem(context, snapshot.data?.docs[index]),
                    itemCount: snapshot.data?.docs.length,
                    controller: listScrollController,
                  );
                } else {
                  return const Center(
                    child: Text("No trading chat history :((("),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffDB36A4),
                  ),
                );
              }
            },
          ),
        )
      ],
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.search, color: Color(0xffaeaeae), size: 20),
          const SizedBox(width: 5),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchBarTec,
              onChanged: (value) {
                searchDebouncer.run(() {
                  if (value.isNotEmpty) {
                    btnClearController.add(true);
                    setState(() {
                      _textSearch = value;
                    });
                  } else {
                    btnClearController.add(false);
                    setState(() {
                      _textSearch = "";
                    });
                  }
                });
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Search name (you have to type exactly string)',
                hintStyle: TextStyle(fontSize: 13, color: Color(0xffaeaeae)),
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          StreamBuilder<bool>(
              stream: btnClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          searchBarTec.clear();
                          btnClearController.add(false);
                          setState(() {
                            _textSearch = "";
                          });
                        },
                        child: const Icon(Icons.clear_rounded,
                            color: Color(0xffaeaeae), size: 20))
                    : const SizedBox.shrink();
              }),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xffE8E8E8),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot? document) {
    if (document != null) {
      TradingMessage tradingMessage = TradingMessage.fromDocument(document);
      if (tradingMessage.sellerId == _currentUserId ||
          tradingMessage.buyerId == _currentUserId) {
        return Container(
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.0, color: Color(0xffE8E8E8)))),
          child: TextButton(
            child: Row(
              children: <Widget>[
                Material(
                  child: _avatar.isNotEmpty
                      ? Image.network(
                          _avatar,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: const Color(0xffDB36A4),
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle,
                              size: 50,
                              color: Color(0xffaeaeae),
                            );
                          },
                        )
                      : const Icon(
                          Icons.account_circle,
                          size: 50,
                          color: Color(0xffaeaeae),
                        ),
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  clipBehavior: Clip.hardEdge,
                ),
                Flexible(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            tradingMessage.title,
                            maxLines: 1,
                            style: const TextStyle(
                                color: Color(0xff203152), fontSize: 16),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.only(left: 15),
                  ),
                ),
              ],
            ),
            onPressed: () {
              if (Utilities.isKeyboardShowing()) {
                Utilities.closeKeyboard(context);
              }
              int peerId;
              if (tradingMessage.sellerId == _currentUserId) {
                peerId = tradingMessage.buyerId;
              } else {
                peerId = tradingMessage.sellerId;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TradingChatPage(
                    arguments: TradingChatPageArguments(
                        token: _token,
                        currentUserId: _currentUserId,
                        peerId: peerId,
                        sellerId: tradingMessage.sellerId,
                        buyerId: tradingMessage.buyerId,
                        title: tradingMessage.title,
                        toyName: tradingMessage.toyName,
                        tradingPostId: tradingMessage.tradingPostId),
                  ),
                ),
              );
            },
          ),
          margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
        );
      } else {
        return SizedBox.shrink();
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
