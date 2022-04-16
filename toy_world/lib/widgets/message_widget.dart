import 'dart:async';

import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/apis/gets/get_user_chat.dart';
import 'package:toy_world/models/model_user_chat.dart';
import 'package:toy_world/screens/chat_page.dart';
import 'package:toy_world/utils/debouncer.dart';

import 'package:toy_world/utils/utilities.dart';

class MessageWidget extends StatefulWidget {
  String token;
  int role;

  MessageWidget({required this.role, required this.token});

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  int _currentUserId = 0;

  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";
  UserChat? data;
  List<User>? users;

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
    super.initState();
    _loadCounter();
    listScrollController.addListener(scrollListener);
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
    });
  }

  getData() async {
    UsersChat usersChat = UsersChat();
    data = await usersChat.getUsersChat(token: widget.token, size: _limit);
    if (data == null) return List.empty();
    users = data!.data!.cast<User>();
    setState(() {});
    return users;
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
          child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (users?.length != null) {
                    return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: users?.length,
                        controller: listScrollController,
                        itemBuilder: (context, index) {
                          return buildItem(context,
                              userChatId: users![index].id,
                              userChatName: users?[index].name ?? "Name",
                              userChatAvatar: users?[index].avatar ?? _avatar,
                              userRole: users?[index].role ?? 2);
                        });
                  } else {
                    return const Center(
                        child: Text("There is no user available :(((("));
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
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

  Widget buildItem(BuildContext context,
      {userChatId, userChatName, userChatAvatar, userRole}) {
    if (users != null) {
      if (userChatId == _currentUserId || (userRole == 0 && widget.role == 2)) {
        return const SizedBox.shrink();
      } else {
        return Container(
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.0, color: Color(0xffE8E8E8)))),
          child: TextButton(
            child: Row(
              children: <Widget>[
                Material(
                  child: userChatAvatar.isNotEmpty
                      ? Image.network(
                          userChatAvatar,
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
                            userChatName,
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    arguments: ChatPageArguments(
                      role: widget.role,
                      token: widget.token,
                      currentUserId: _currentUserId,
                      peerId: userChatId,
                      peerAvatar: userChatAvatar,
                      peerName: userChatName,
                    ),
                  ),
                ),
              );
            },
          ),
          margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
