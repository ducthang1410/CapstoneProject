import 'package:flutter/material.dart';
import 'package:toy_world/apis/gets/get_comment_post.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_comment.dart';
import 'package:toy_world/models/model_image_post.dart';
import 'package:toy_world/models/model_post_detail.dart';
import 'package:toy_world/widgets/comment_widget.dart';
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
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    CommentPostList commentPost = CommentPostList();
    data = await commentPost.getCommentPost(
        token: widget.token, postId: widget.postID);
    if (data == null) return List.empty();
    comments = data!.comments!.cast<Comment>();
    setState(() {});
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            sideAppBar(context, widget.role, widget.token),
            FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                return data != null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PostWidget(
                            role: widget.role,
                            token: widget.token,
                            postId: data!.id,
                            isPostDetail: true,
                            ownerId: data!.ownerId,
                            ownerAvatar: data?.ownerAvatar ?? _avatar,
                            ownerName: data?.ownerName ?? "Name",
                            isLikedPost: data?.isLikedPost ?? false,
                            timePublic: data?.postDate ?? DateTime.now(),
                            content: data?.content ?? "",
                            images: data?.images ?? [],
                            numOfReact: data?.numOfReact ?? 0,
                            numOfComment: data?.numOfComment ?? 0,
                            isReadMore: data?.isReadMore ?? false,
                          ),
                          CommentWidget(
                            role: widget.role,
                            token: widget.token,
                            postID: widget.postID,
                            ownerPostId: data!.ownerId,
                            comments: comments ?? [],
                            type: "Post",
                          ),
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              }
            ),
          ],
        ),
      ),
    );
  }
}
