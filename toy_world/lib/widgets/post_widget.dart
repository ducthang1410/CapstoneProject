import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toy_world/screens/post_detail_page.dart';

import 'package:toy_world/utils/helpers.dart';
import 'package:toy_world/widgets/comment_widget.dart';

class PostWidget extends StatefulWidget {
  int role;
  String token;
  int? postId;
  bool? isPostDetail;
  String? imgAvatar;
  String? ownerName;
  DateTime? timePublic;
  String? content;
  String? images;
  int? numOfReact;
  int? numOfComment;

  PostWidget(
      {required this.role,
      required this.token,
      required this.postId,
      required this.isPostDetail,
      required this.imgAvatar,
      required this.ownerName,
      required this.timePublic,
      required this.content,
      required this.images,
      required this.numOfReact,
      required this.numOfComment});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return _post(
        imgAvatar: widget.imgAvatar,
        ownerName: widget.ownerName,
        timePublic: widget.timePublic,
        content: widget.content,
        images: widget.images,
        numOfReact: widget.numOfReact,
        numOfComment: widget.numOfComment);
  }

  Widget _post(
      {imgAvatar,
      ownerName,
      timePublic,
      content,
      images,
      numOfReact,
      numOfComment}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _postHeader(
                    imgAvatar: imgAvatar,
                    ownerName: ownerName,
                    timePublic: timePublic),
                const SizedBox(
                  height: 4.0,
                ),
                Text(content),
                images != null
                    ? const SizedBox.shrink()
                    : const SizedBox(
                        height: 6.0,
                      ),
              ],
            ),
          ),
          images != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Post%2FPostImage.jpg?alt=media&token=067a93a0-516d-4d11-bb03-bb7b57c99530",
                  ))
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child:
                _postStats(numOfReact: numOfReact, numOfComment: numOfComment),
          ),
        ],
      ),
    );
  }

  Widget _postHeader({imgAvatar, ownerName, timePublic}) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(timePublic);
    String formattedDate = timeControl(difference);
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[200],
          backgroundImage: CachedNetworkImageProvider(imgAvatar),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ownerName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Text(
                    formattedDate + " *",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
                  )
                ],
              )
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
        )
      ],
    );
  }

  Widget _postStats({numOfReact, numOfComment}) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
              child: const Icon(
                FontAwesomeIcons.heart,
                size: 10.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 4.0,
            ),
            Expanded(
                child: Text(
              "$numOfReact",
              style: TextStyle(color: Colors.grey[600]),
            )),
            Text(
              "$numOfComment Comments",
              style: TextStyle(color: Colors.grey[600]),
            )
          ],
        ),
        const Divider(),
        Row(
          children: [
            _postButton(
              Icon(
                FontAwesomeIcons.heart,
                color: Colors.grey[600],
                size: 20,
              ),
              "Love",
              onTap: () => print("Love"),
            ),
            _postButton(
              Icon(
                FontAwesomeIcons.comment,
                color: Colors.grey[600],
                size: 20,
              ),
              "Comment",
              onTap: () => widget.isPostDetail == false
                  ? Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PostDetailPage(
                            role: widget.role,
                            token: widget.token,
                            postID: widget.postId,
                          )))
                  : () {},
            )
          ],
        ),
        widget.isPostDetail == true ? Column(
          children: [
            const Divider(),
            CommentWidget(role: widget.role, token: widget.token, postID: widget.postId)
          ],
        ) : const SizedBox(),
      ],
    );
  }

  Widget _postButton(Icon icon, String label, {onTap}) {
    return Expanded(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 25.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(
                  width: 4.0,
                ),
                Text(label)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
