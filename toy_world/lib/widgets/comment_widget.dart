import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toy_world/apis/deletes/delete_comment.dart';
import 'package:toy_world/apis/gets/get_comment_post.dart';
import 'package:toy_world/apis/posts/post_comment_post.dart';
import 'package:toy_world/apis/puts/put_update_comment.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_comment.dart';
import 'package:toy_world/models/model_post_detail.dart';
import 'package:toy_world/utils/helpers.dart';

class CommentWidget extends StatefulWidget {
  int role;
  String token;
  int? postID;

  CommentWidget({
    required this.role,
    required this.token,
    required this.postID,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  PostDetail? data;
  List<Comment>? comments;
  String _avatar =
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

  getData() async {
    CommentPostList commentPost = CommentPostList();
    data = await commentPost.getCommentPost(
        token: widget.token, postId: widget.postID);
    if (data == null) return List.empty();
    comments = data!.comments!.cast<Comment>();
    setState(() {});
    return comments;
  }

  _loadCounter() async {
    _avatar = await getDataSession(key: "avatar");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _writeComment(ownerAvatar: _avatar),
        FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (comments?.length != null) {
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: comments?.length,
                      itemBuilder: (context, index) {
                        return _comment(
                            commentID: comments![index].id,
                            ownerAvatar: comments![index].ownerAvatar,
                            ownerName: comments![index].ownerName,
                            content: comments![index].content,
                            numOfReact: comments![index].numOfReact);
                      });
                }
              }
              return const SizedBox();
            }),
      ],
    );
  }

  Widget _writeComment({
    ownerAvatar,
  }) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            backgroundImage: CachedNetworkImageProvider(ownerAvatar),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
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
            onPressed: () async {
              try {
                if (await checkCreateComment(
                        token: widget.token,
                        postId: widget.postID,
                        content: controller.text) ==
                    200) {
                  controller.clear();
                } else {
                  loadingFail(
                      status:
                          "Comment Failed - ${await checkCreateComment(token: widget.token, postId: widget.postID, content: controller.text)}");
                }
              } catch (e) {
                loadingFail(status: "Comment Failed !!! \n $e");
              }
            },
          )
        ]));
  }

  Widget _comment({commentID, ownerAvatar, ownerName, content, numOfReact}) {
    bool isEdited = false;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            backgroundImage: CachedNetworkImageProvider(ownerAvatar),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey.shade200),
              child: isEdited == false
                  ? Column(
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
                    )
                  : TextFormField(
                      initialValue: content,
                      controller: controller,
                      decoration: InputDecoration(
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
          ),
          isEdited == false
              ? PopupMenuButton(
                  icon: const Icon(Icons.more_horiz),
                  onSelected: (int value) {
                    if(value == 1){
                      isEdited = true;
                    }
                    setState(() {
                      _choiceComment = value;
                      selectedPopupMenuButton(
                          value: _choiceComment,
                          token: widget.token,
                          commentID: commentID,
                          isEdited: isEdited);
                    });
                  },
                  itemBuilder: (context) => const [
                        PopupMenuItem(
                          child: Text("Edit"),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: Text("Delete"),
                          value: 2,
                        )
                      ])
              : IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.arrowCircleRight,
                    color: Color(0xffDB36A4),
                  ),
                  onPressed: () async {
                    isEdited = false;
                    UpdateComment comment = UpdateComment();
                    int status = await comment.updateComment(
                        token: widget.token,
                        commentId: commentID,
                        content: controller.text);
                    if (status == 200) {
                      setState(() {});
                    } else {
                      loadingFail(status: "Edit Failed !!!");
                    }
                  },
                )
        ],
      ),
    );
  }

  checkCreateComment({token, postId, content}) async {
    CommentPost comment = CommentPost();
    var status = await comment.commentPost(
        token: token, postId: postId, content: content);
    return status;
  }

  selectedPopupMenuButton({value, token, commentID, bool? isEdited}) async {
    switch (value) {
      case 1:
        print(isEdited);
        setState(() {});
        break;
      case 2:
        DeleteComment comment = DeleteComment();
        int status =
            await comment.deleteComment(token: token, commentId: commentID);
        if (status == 200) {
          setState(() {});
        } else {
          loadingFail(status: "Delete Failed !!!");
        }
        break;
    }
  }
}
