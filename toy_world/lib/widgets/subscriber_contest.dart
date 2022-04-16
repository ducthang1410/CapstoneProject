import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/apis/deletes/delete_subscriber.dart';
import 'package:toy_world/apis/gets/get_subscribers.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_subscriber.dart';
import 'package:toy_world/screens/chat_page.dart';

class SubscriberContestWidget extends StatefulWidget {
  int role;
  String token;
  int contestId;

  SubscriberContestWidget(
      {required this.role, required this.token, required this.contestId});

  @override
  State<SubscriberContestWidget> createState() =>
      _SubscriberContestWidgetState();
}

class _SubscriberContestWidgetState extends State<SubscriberContestWidget> {
  int _currentUserId = 0;
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";
  List<Subscriber>? subscribers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = (prefs.getInt('accountId') ?? 0);
    });
  }

  getSubscribersContest() async {
    SubscribersContest subscribersContest = SubscribersContest();
    subscribers = await subscribersContest.getSubscribersContest(
        token: widget.token, contestId: widget.contestId);
    if (subscribers == null) return List.empty();
    setState(() {});
    return subscribers;
  }

  showConfirmDialog(int id, Size size) => showDialog(context: context, builder: (context) => Center(
    child: AlertDialog(title: const Text(
      "Confirm Ban Account",
      style: TextStyle(color: Color(0xffDB36A4), fontSize: 26),
      textAlign: TextAlign.center,
    ),
      content: SizedBox(
        height: size.height * 0.25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Are you sure to ban this account? This account can not join in after banned."),
            Flexible(
              child: Padding(
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
                            "Confirm",
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.0),
                          ),
                          onPressed: () async {
                            DeleteSubscriber subscriber = DeleteSubscriber();
                            int status =
                            await subscriber.deleteSubscriber(token: widget.token, contestId: widget.contestId, accountId: id);
                            if (status == 200) {
                              setState(() {});
                              loadingSuccess(status: "Ban success");
                              Navigator.of(context).pop();
                            } else {
                              loadingFail(status: "Ban Failed !!!");
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  ));

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: FutureBuilder(
            future: getSubscribersContest(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (subscribers?.length != null && subscribers!.isNotEmpty) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: subscribers?.length,
                      itemBuilder: (context, index) {
                        return buildSubscriber(
                            id: subscribers?[index].id ?? 0,
                            avatar: subscribers?[index].avatar ?? _avatar,
                            name: subscribers?[index].name ?? "Name",
                            phone: subscribers?[index].phone ?? "");
                      });
                } else {
                  return const Center(
                      child: Text("There hasn't had any subscriber yet !!!"));
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  Widget buildSubscriber({id, avatar, name, phone}) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.grey.shade300),
          bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Material(
                child: Image.network(
                  avatar,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      width: 60,
                      height: 60,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: const Color(0xffDB36A4),
                          value: loadingProgress.expectedTotalBytes != null
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
                      size: 60,
                      color: Color(0xffaeaeae),
                    );
                  },
                ),
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                clipBehavior: Clip.hardEdge,
              ),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16.0),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: [
                        Text(
                          "Phone: " + phone,
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 14.0),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 125,
                height: 60,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10.0,),
                        Text(
                          "Ban",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ],
                    ),
                    onPressed: () {
                      showConfirmDialog(id, size);
                    }),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Container(
                width: 125,
                height: 60,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey.shade300),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.commentDots,
                          color: Colors.black87,
                        ),
                        SizedBox(width: 10.0,),
                        Text("Chat", style: TextStyle(fontSize: 16, color: Colors.black87),)
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            arguments: ChatPageArguments(
                              role: widget.role,
                              token: widget.token,
                              currentUserId: _currentUserId,
                              peerId: id,
                              peerAvatar: avatar,
                              peerName: name,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }

}
