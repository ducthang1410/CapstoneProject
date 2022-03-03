import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toy_world/apis/gets/get_comment_post.dart';
import 'package:toy_world/models/model_comment.dart';
import 'package:toy_world/models/model_post_detail.dart';

class CommentWidget extends StatefulWidget {
  // String? ownerAvatar;
  // String? ownerName;
  // String? content;
  // int? numOfReact;

  int role;
  String token;
  int? postID;

  CommentWidget({required this.role,
    required this.token,
    required this.postID,
    // required this.ownerAvatar,
    // required this.ownerName,
    // required this.content,
    // required this.numOfReact,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  PostDetail? data;
  List<Comment>? comments;

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
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (comments?.length != null) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: comments?.length,
                  itemBuilder: (context, index) {
                    return _comment(
                        ownerAvatar: comments![index].ownerAvatar,
                        ownerName: comments![index].ownerName,
                        content: comments![index].content,
                        numOfReact: comments![index].numOfReact);
                  });
            }
          }
          return const SizedBox();
        });
  }

  Widget _comment({ownerAvatar, ownerName, content, numOfReact}) {
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                    style: const TextStyle(color: Colors.black, fontSize: 18.0),
                  )
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
