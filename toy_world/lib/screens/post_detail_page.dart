import 'package:flutter/material.dart';
import 'package:toy_world/apis/gets/get_comment_post.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_comment.dart';
import 'package:toy_world/models/model_post_detail.dart';
import 'package:toy_world/widgets/post_widget.dart';

class PostDetailPage extends StatefulWidget {
  int role;
  String token;
  int? postID;

  PostDetailPage(
      {required this.role, required this.token, required this.postID});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  PostDetail? data;
  List<Comment>? comments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          sideAppBar(context),
          data != null
              ? PostWidget(
                  role: widget.role,
                  token: widget.token,
                  postId: data!.id,
                  isPostDetail: true,
                  imgAvatar: data!.ownerAvatar,
                  ownerName: data!.ownerName,
                  timePublic: data!.publicDate,
                  content: data!.content,
                  images: data!.ownerAvatar,
                  numOfReact: data!.numOfReact,
                  numOfComment: data!.numOfComment)
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }
}
