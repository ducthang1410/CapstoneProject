import 'package:flutter/material.dart';
import 'dart:math';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toy_world/apis/puts/put_react_post.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_image_post.dart';
import 'package:toy_world/screens/post_detail_page.dart';

import 'package:toy_world/utils/helpers.dart';
import 'package:toy_world/widgets/comment_widget.dart';

class PostWidget extends StatefulWidget {
  int role;
  String token;
  int? postId;
  bool? isPostDetail;
  String? ownerAvatar;
  String? ownerName;
  bool? isLikedPost;
  DateTime? timePublic;
  String? content;
  List<ImagePost>? images;
  int? numOfReact;
  int? numOfComment;

  PostWidget(
      {required this.role,
      required this.token,
      required this.postId,
      required this.isPostDetail,
      required this.ownerAvatar,
      required this.ownerName,
      required this.isLikedPost,
      required this.timePublic,
      required this.content,
      this.images,
      required this.numOfReact,
      required this.numOfComment});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  int _choice = 0;

  @override
  Widget build(BuildContext context) {
    return _post(
        ownerAvatar: widget.ownerAvatar,
        ownerName: widget.ownerName,
        isLikedPost: widget.isLikedPost,
        timePublic: widget.timePublic,
        content: widget.content,
        images: widget.images,
        numOfReact: widget.numOfReact,
        numOfComment: widget.numOfComment);
  }

  Widget _post(
      {ownerAvatar,
      ownerName,
      isLikedPost,
      timePublic,
      content,
      List<ImagePost>? images,
      numOfReact,
      numOfComment}) {
    var size = MediaQuery.of(context).size;
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
                    ownerAvatar: ownerAvatar,
                    ownerName: ownerName,
                    timePublic: timePublic),
                const SizedBox(
                  height: 4.0,
                ),
                Text(content),
                images!.isNotEmpty
                    ? const SizedBox.shrink()
                    : const SizedBox(
                        height: 6.0,
                      ),
              ],
            ),
          ),
          images!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GridView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    primary: false,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: size.width * 0.5,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    children: buildImages(),
                  ),
                )
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: _postStats(
                isLikedPost: isLikedPost,
                numOfReact: numOfReact,
                numOfComment: numOfComment),
          ),
        ],
      ),
    );
  }

  Widget _postHeader({ownerAvatar, ownerName, timePublic}) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(timePublic);
    String formattedDate = timeControl(difference);
    return Row(
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
        PopupMenuButton(
            icon: const Icon(Icons.more_horiz),
            onSelected: (int value) {
              setState(() {
                _choice = value;
                selectedPopupMenuButton(_choice);
              });
            },
            itemBuilder: (context) => const [
                  PopupMenuItem(
                    child: Text("Feedback"),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text("Delete post"),
                    value: 2,
                  )
                ]),
      ],
    );
  }

  Widget _postStats({isLikedPost, numOfReact, numOfComment}) {
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
                color: isLikedPost ? Colors.red : Colors.grey[600],
                size: 20,
              ),
              Text(
                "Love",
                style: TextStyle(
                  color: isLikedPost ? Colors.red : Colors.grey[600],
                ),
              ),
              onTap: () =>
                  reactPost(token: widget.token, postId: widget.postId),
            ),
            _postButton(
              Icon(
                FontAwesomeIcons.comment,
                color: Colors.grey[600],
                size: 20,
              ),
              const Text("Comment"),
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
        widget.isPostDetail == true
            ? Column(
                children: [
                  const Divider(),
                  CommentWidget(
                      role: widget.role,
                      token: widget.token,
                      postID: widget.postId)
                ],
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _postButton(Icon icon, Text text, {onTap}) {
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
                text
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildImages() {
    int numImages = widget.images!.length;
    int maxImages = 4;
    return List<Widget>.generate(min(numImages, maxImages), (index) {
      String? imageUrl = widget.images![index].url;

      // If its the last image
      if (index == maxImages - 1) {
        // Check how many more images are left
        int remaining = numImages - maxImages;

        // If no more are remaining return a simple image widget
        if (remaining == 0) {
          return GestureDetector(
            child: CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Image.network(
                "https://www.trendsetter.com/pub/media/catalog/product/placeholder/default/no_image_placeholder.jpg",
                fit: BoxFit.cover,
              ),
            ),
            onTap: () {
              onImageClicked(index);
            },
          );
        } else {
          // Create the facebook like effect for the last image with number of remaining  images
          return GestureDetector(
            onTap: () => onExpandClicked(),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.network(
                    "https://www.trendsetter.com/pub/media/catalog/product/placeholder/default/no_image_placeholder.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black54,
                    child: Text(
                      '+' + remaining.toString(),
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        return GestureDetector(
          child: CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Image.network(
                    "https://www.trendsetter.com/pub/media/catalog/product/placeholder/default/no_image_placeholder.jpg",
                    fit: BoxFit.cover,
                  )),
          onTap: () {
            onImageClicked(index);
          },
        );
      }
    });
  }

  selectedPopupMenuButton(int value, {token}) {
    switch (value) {
      case 1:
        print(value);
        break;
      case 2:
        print(value);
        break;
    }
  }

  reactPost({token, postId}) async {
    ReactPost react = ReactPost();
    int status = await react.reactPost(token: token, postId: postId);
    if (status == 200) {
      setState(() {});
    } else {
      loadingFail(status: "Love Failed !!!");
    }
    setState(() {});
  }
}
