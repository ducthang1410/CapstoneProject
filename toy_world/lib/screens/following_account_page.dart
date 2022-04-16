import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toy_world/apis/gets/get_following_account.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_following_account.dart';
import 'package:toy_world/screens/chat_page.dart';
import 'package:toy_world/screens/profile_page.dart';

class FollowingPage extends StatefulWidget {
  int role;
  String token;
  int currentUserId;

  FollowingPage(
      {required this.token, required this.role, required this.currentUserId});

  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  List<FollowingAccount>? data;

  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";

  getData() async {
    FollowingAccountList accounts = FollowingAccountList();
    data = await accounts.getFollowingAccount(
        token: widget.token, accountId: widget.currentUserId);
    if (data == null) return List.empty();
    setState(() {});
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sideAppBar(context, widget.role, widget.token),
        Expanded(
            child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (data?.length != null && data!.isNotEmpty) {
                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: data?.length,
                          itemBuilder: (context, index) {
                            return _account(id: data?[index].id, name: data?[index].name ?? "Name", avatar: data?[index].avatar ?? _avatar);
                          });
                    } else {
                      return const Center(
                          child: Text("There is no account available:(((("));
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }))
      ],
    );
  }

  Widget _account({id, avatar, name}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.grey.shade300),
          bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePage(
                  role: widget.role,
                  token: widget.token,
                  accountId: id,
                ))),
            child: Material(
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
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Text(
              name,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
            ),
          ),
          Container(
            width: 100,
            height: 50,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xffDB36A4)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                child: const Icon(
                  FontAwesomeIcons.commentDots,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        arguments: ChatPageArguments(
                          role: widget.role,
                          token: widget.token,
                          currentUserId: widget.currentUserId,
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
      ),
    );
  }
}
