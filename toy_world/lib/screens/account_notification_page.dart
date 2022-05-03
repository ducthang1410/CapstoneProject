import 'package:flutter/material.dart';
import 'package:toy_world/apis/gets/get_account_notification.dart';
import 'package:toy_world/apis/puts/put_readed_notification.dart';
import 'package:toy_world/models/model_contest_detail.dart';
import 'package:toy_world/models/model_notification.dart';
import 'package:toy_world/screens/contest_page.dart';
import 'package:toy_world/screens/post_detail_page.dart';
import 'package:toy_world/screens/trading_post_detail_page.dart';
import 'package:toy_world/utils/helpers.dart';

class AccountNotificationPage extends StatefulWidget {
  int role;
  String token;
  int accountId;

  AccountNotificationPage(
      {required this.role, required this.token, required this.accountId});

  @override
  State<AccountNotificationPage> createState() =>
      _AccountNotificationPageState();
}

class _AccountNotificationPageState extends State<AccountNotificationPage> {
  AccountNotifications? data;
  List<AccountNotification>? notifications;

  int _limit = 10;
  final int _limitIncrement = 10;

  final ScrollController listScrollController = ScrollController();

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
    AccountNotificationList notificationList = AccountNotificationList();
    data = await notificationList.getAccountNotificationList(
        token: widget.token, accountId: widget.accountId, size: _limit);
    if (data == null) return List.empty();
    notifications = data!.data!.cast<AccountNotification>();
    setState(() {});
    return notifications;
  }

  movePage({postId, tradingPostId, contestId, postOfContestId}) {
    if (postId != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PostDetailPage(
              role: widget.role, token: widget.token, postID: postId)));
    } else if (tradingPostId != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TradingPostDetailPage(
              role: widget.role,
              token: widget.token,
              tradingPostID: tradingPostId)));
    } else if (contestId != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ContestPage(
              role: widget.role, token: widget.token, contestId: contestId)));
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (notifications?.length != null && notifications!.isNotEmpty) {
                return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: notifications?.length,
                    controller: listScrollController,
                    itemBuilder: (context, index) {
                      return _notification(
                        id: notifications?[index].id,
                        content: notifications?[index].content ?? "",
                        createTime:
                            notifications?[index].createTime ?? DateTime.now(),
                        isRead: notifications?[index].isReaded ?? false,
                        postId: notifications?[index].postId,
                        tradingPostId: notifications?[index].tradingPostId,
                        contestId: notifications?[index].contestId,
                      );
                    });
              } else {
                return const Center();
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget _notification(
      {id, content, createTime, isRead, postId, tradingPostId, contestId}) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(createTime);
    String formattedDate = timeControl(difference);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: isRead == false ? Colors.grey.shade300 : Colors.white,
      ),
      child: GestureDetector(
        onTap: isRead == false
            ? () async {
                ReadNotification isRead = ReadNotification();
                isRead.readNotification(
                    token: widget.token, notificationId: id);
                setState(() {});
                movePage(
                    postId: postId,
                    tradingPostId: tradingPostId,
                    contestId: contestId);
              }
            : () {
                movePage(
                    postId: postId,
                    tradingPostId: tradingPostId,
                    contestId: contestId);
              },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isRead == false ? FontWeight.bold : null),
            ),
            Text(
              formattedDate,
              style: TextStyle(
                  color:
                      isRead == false ? const Color(0xffDB36A4) : Colors.grey,
                  fontWeight: isRead == false ? FontWeight.bold : null),
            )
          ],
        ),
      ),
    );
  }
}
