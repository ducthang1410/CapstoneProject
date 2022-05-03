import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/apis/gets/get_comment_post.dart';
import 'package:toy_world/apis/gets/get_trading_post_detail.dart';
import 'package:toy_world/apis/puts/put_reply_feedback.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_feedback.dart';
import 'package:toy_world/models/model_post_detail.dart';
import 'package:toy_world/models/model_trading_post_detail.dart';
import 'package:toy_world/screens/profile_page.dart';
import 'package:toy_world/utils/helpers.dart';
import 'package:toy_world/widgets/post_widget.dart';
import 'package:toy_world/widgets/trading_post_widget.dart';

class FeedbackDetailPage extends StatefulWidget {
  int role;
  String token;
  FeedbackModel feedback;

  FeedbackDetailPage(
      {required this.role, required this.token, required this.feedback});

  @override
  State<FeedbackDetailPage> createState() => _FeedbackDetailPageState();
}

class _FeedbackDetailPageState extends State<FeedbackDetailPage> {
  PostDetail? post;
  TradingPostDetail? tradingPost;

  late TextEditingController controller;

  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";

  String replyAvatar = "";

  @override
  void initState() {
    // TODO: implement initState
    _loadCounter();
    controller = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    getContent();
    super.initState();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      replyAvatar = (prefs.getString('avatar') ?? "");
    });
  }

  getContent() async {
    if (widget.feedback.feedbackAbout == "post") {
      CommentPostList commentPost = CommentPostList();
      post = await commentPost.getCommentPost(
          token: widget.token, postId: widget.feedback.idForDetail);
      if (post == null) return List.empty();
      setState(() {});
      return post;
    } else if (widget.feedback.feedbackAbout == "trading") {
      TradingPostDetailData detail = TradingPostDetailData();
      tradingPost = await detail.getTradingPostDetail(
          token: widget.token, tradingPostId: widget.feedback.idForDetail);
      if (tradingPost == null) return List.empty();
      setState(() {});
      return tradingPost;
    } else {
      return;
    }
  }

  checkReplyFeedback({token, feedbackId, content}) async {
    ReplyFeedback replyFeedback = ReplyFeedback();
    var status = await replyFeedback.replyFeedback(
        token: token, feedbackId: feedbackId, content: content);
    return status;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    Duration difference =
        now.difference(widget.feedback.sendDate ?? DateTime.now());
    String formattedDate = timeControl(difference);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            sideAppBar(context, widget.role, widget.token),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
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
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                      role: widget.role,
                                      token: widget.token,
                                      accountId: widget.feedback.senderId ?? 0,
                                    ))),
                        child: Material(
                          child: Image.network(
                            widget.feedback.senderAvatar ?? "",
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
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          clipBehavior: Clip.hardEdge,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.feedback.senderName ?? "Name",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18.0),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Reason: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      Expanded(
                        child: Text(
                          widget.feedback.content ?? "",
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                  widget.feedback.feedbackAbout == "post"
                      ? post != null
                          ? Column(
                              children: [
                                const Divider(),
                                PostWidget(
                                  role: widget.role,
                                  token: widget.token,
                                  postId: post!.id,
                                  isPostDetail: false,
                                  ownerId: post!.ownerId,
                                  ownerAvatar: post?.ownerAvatar ?? _avatar,
                                  ownerName: post?.ownerName ?? "Name",
                                  isLikedPost: post?.isLikedPost ?? false,
                                  timePublic: post?.postDate ?? DateTime.now(),
                                  content: post?.content ?? "",
                                  images: post?.images ?? [],
                                  numOfReact: post?.numOfReact ?? 0,
                                  numOfComment: post?.numOfComment ?? 0,
                                  isReadMore: post?.isReadMore ?? false,
                                ),
                                const Divider(),
                              ],
                            )
                          : const Center()
                      : const SizedBox.shrink(),
                  widget.feedback.feedbackAbout == "trading"
                      ? tradingPost != null
                          ? Column(
                              children: [
                                const Divider(),
                                TradingPostWidget(
                                  role: widget.role,
                                  token: widget.token,
                                  tradingPostId: tradingPost!.id,
                                  isPostDetail: false,
                                  ownerId: tradingPost!.ownerId,
                                  ownerAvatar:
                                      tradingPost?.ownerAvatar ?? _avatar,
                                  ownerName: tradingPost?.ownerName ?? "Name",
                                  isLikedPost: tradingPost?.isReact ?? false,
                                  status: tradingPost!.status,
                                  postDate:
                                      tradingPost?.postDate ?? DateTime.now(),
                                  title: tradingPost!.title,
                                  content: tradingPost!.content,
                                  toyName: tradingPost?.toyName ?? "",
                                  address: tradingPost?.address ?? "Unknown",
                                  phoneNum: tradingPost?.phone ?? "Unknown",
                                  exchange: tradingPost?.trading ?? "",
                                  value: tradingPost?.value,
                                  images: tradingPost?.images ?? [],
                                  numOfReact:
                                      tradingPost?.numOfReact?.toInt() ?? 0,
                                  numOfComment:
                                      tradingPost?.numOfComment?.toInt() ?? 0,
                                  isReadMore: tradingPost?.isReadMore ?? false,
                                  isDisable: false,
                                ),
                                const Divider(),
                              ],
                            )
                          : Column(
                            children: const [
                              Divider(),
                              SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Text(
                                      "This post is being disabled",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.red),
                                    ),
                                  )),
                              Divider(),
                            ],
                          )
                      : const SizedBox.shrink(),
                  _writeComment(),
                  widget.feedback.replierId != null &&
                          widget.feedback.replyContent != null
                      ? _replyFeedback()
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _writeComment() {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[200],
            backgroundImage: CachedNetworkImageProvider(replyAvatar),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Reply feedback ...",
                filled: true,
                fillColor: Colors.grey[300],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.send,
              color: Color(0xffDB36A4),
            ),
            onPressed: controller.text != ""
                ? () async {
                    try {
                      loadingLoad(status: "Loading...");
                      if (await checkReplyFeedback(
                              token: widget.token,
                              feedbackId: widget.feedback.id,
                              content: controller.text) ==
                          200) {
                        EasyLoading.dismiss();
                        controller.clear();
                        Navigator.of(context).pop();
                      } else {
                        loadingFail(
                            status:
                                "Reply Failed - ${await checkReplyFeedback(token: widget.token, feedbackId: widget.feedback.id, content: controller.text)}");
                      }
                    } catch (e) {
                      loadingFail(status: "Reply Failed !!! \n $e");
                    }
                  }
                : null,
          )
        ]));
  }

  Widget _replyFeedback() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[200],
            backgroundImage: CachedNetworkImageProvider(
                widget.feedback.replierAvatar ?? _avatar),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey.shade200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.feedback.replierName ?? "Manager",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      widget.feedback.replyContent ?? "",
                      style:
                          const TextStyle(color: Colors.black, fontSize: 18.0),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
