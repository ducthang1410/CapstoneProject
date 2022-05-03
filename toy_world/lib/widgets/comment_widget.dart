import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/apis/deletes/delete_comment.dart';
import 'package:toy_world/apis/posts/post_comment_post.dart';
import 'package:toy_world/apis/posts/post_comment_trading_post.dart';
import 'package:toy_world/apis/puts/put_react_comment.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_comment.dart';
import 'package:toy_world/utils/helpers.dart';

class CommentWidget extends StatefulWidget {
  int role;
  String token;
  int? postID;
  int? ownerPostId;
  List<Comment> comments;
  String type;

  CommentWidget(
      {required this.role,
      required this.token,
      required this.postID,
      required this.ownerPostId,
      required this.comments,
      required this.type});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  int _currentUserId = 0;
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";
  String ownerAvatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";

  late TextEditingController controller;
  int _choiceComment = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCounter();
    controller = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = (prefs.getInt('accountId') ?? 0);
      _avatar = (prefs.getString('avatar') ?? "");
    });
  }

  reactComment({token, commentId}) async {
    loadingLoad(status: "Loading...");
    ReactComment react = ReactComment();
    int status = await react.reactComment(token: token, commentId: commentId);
    if (status == 200) {
      EasyLoading.dismiss();
      setState(() {});
    } else {
      loadingFail(status: "Love Failed !!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 20),
      child: Column(
        children: [
          _writeComment(),
          widget.comments.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.comments.length,
                  itemBuilder: (context, index) {
                    return _comment(
                        commentID: widget.comments[index].id,
                        ownerId: widget.comments[index].ownerId,
                        ownerAvatar: widget.comments[index].ownerAvatar,
                        ownerName: widget.comments[index].ownerName ?? "Name",
                        commentDate: widget.comments[index].commentDate ??
                            DateTime.now(),
                        content: widget.comments[index].content,
                        numOfReact: widget.comments[index].numOfReact,
                        isReacted: widget.comments[index].isReacted ?? false);
                  })
              : const SizedBox.shrink()
        ],
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
            backgroundImage: CachedNetworkImageProvider(_avatar),
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
                hintText: "Write a comment ...",
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
                      if (widget.type == "Post") {
                        if (await checkCreateCommentPost(
                                token: widget.token,
                                postId: widget.postID,
                                content: controller.text) ==
                            200) {
                          EasyLoading.dismiss();
                          controller.clear();
                        } else {
                          loadingFail(
                              status:
                                  "Comment Failed - ${await checkCreateCommentPost(token: widget.token, postId: widget.postID, content: controller.text)}");
                        }
                      } else if (widget.type == "TradingPost") {
                        if (await checkCreateCommentTradingPost(
                                token: widget.token,
                                tradingPostId: widget.postID,
                                content: controller.text) ==
                            200) {
                          controller.clear();
                        } else {
                          loadingFail(
                              status:
                                  "Comment Failed - ${await checkCreateCommentTradingPost(token: widget.token, tradingPostId: widget.postID, content: controller.text)}");
                        }
                      }
                    } catch (e) {
                      loadingFail(status: "Comment Failed !!! \n $e");
                    }
                  }
                : null,
          )
        ]));
  }

  Widget _comment(
      {commentID,
      ownerId,
      ownerAvatar,
      ownerName,
      commentDate,
      content,
      numOfReact,
      isReacted}) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(commentDate);
    String formattedDate = timeControl(difference);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[200],
                backgroundImage: CachedNetworkImageProvider(ownerAvatar),
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
                          ownerName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          content,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18.0),
                        )
                      ],
                    )),
              ),
              _currentUserId == ownerId ||
                      widget.ownerPostId == _currentUserId ||
                      widget.role == 1
                  ? PopupMenuButton(
                      icon: const Icon(Icons.more_horiz),
                      onSelected: (int value) {
                        setState(() {
                          _choiceComment = value;
                          selectedPopupMenuButton(
                            value: _choiceComment,
                            token: widget.token,
                            commentID: commentID,
                          );
                        });
                      },
                      itemBuilder: (context) =>
                          widget.ownerPostId == _currentUserId ||
                                  widget.role == 1
                              ? const [
                                  PopupMenuItem(
                                    child: Text("Delete"),
                                    value: 2,
                                  )
                                ]
                              : const [
                                  PopupMenuItem(
                                    child: Text("Delete"),
                                    value: 2,
                                  )
                                ])
                  : const SizedBox.shrink()
            ],
          ),
          Container(
            height: 20,
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () =>
                        reactComment(token: widget.token, commentId: commentID),
                    child: Text(
                      "Love",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isReacted ? Colors.red : Colors.grey[600],
                      ),
                    )),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    formattedDate,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  checkCreateCommentPost({token, postId, content}) async {
    CommentPost comment = CommentPost();
    var status = await comment.commentPost(
        token: token, postId: postId, content: content);
    return status;
  }

  checkCreateCommentTradingPost({token, tradingPostId, content}) async {
    CommentTradingPost comment = CommentTradingPost();
    var status = await comment.commentTradingPost(
        token: token, tradingPostId: tradingPostId, content: content);
    return status;
  }

  selectedPopupMenuButton({value, token, commentID}) async {
    switch (value) {
      case 1:
        setState(() {});
        break;
      case 2:
        loadingLoad(status: "Loading...");
        DeleteComment comment = DeleteComment();
        int status =
            await comment.deleteComment(token: token, commentId: commentID);
        if (status == 200) {
          EasyLoading.dismiss();
          setState(() {});
        } else {
          loadingFail(status: "Delete Failed !!!");
        }
        break;
    }
  }
}
