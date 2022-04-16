import 'package:flutter/material.dart';
import 'dart:math';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/apis/deletes/delete_post.dart';
import 'package:toy_world/apis/posts/post_feedback_post.dart';
import 'package:toy_world/apis/puts/put_react_post.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_image_post.dart';
import 'package:toy_world/screens/post_detail_page.dart';
import 'package:toy_world/screens/profile_page.dart';

import 'package:toy_world/utils/helpers.dart';
import 'package:toy_world/widgets/comment_widget.dart';

class PostWidget extends StatefulWidget {
  int role;
  String token;
  int? postId;
  bool? isPostDetail;
  int? ownerId;
  String? ownerAvatar;
  String? ownerName;
  bool? isLikedPost;
  DateTime? timePublic;
  String? content;
  List<ImagePost>? images;
  int? numOfReact;
  int? numOfComment;
  bool? isReadMore;

  PostWidget(
      {required this.role,
      required this.token,
      required this.postId,
      required this.isPostDetail,
      required this.ownerId,
      required this.ownerAvatar,
      required this.ownerName,
      required this.isLikedPost,
      required this.timePublic,
      required this.content,
      this.images,
      required this.numOfReact,
      required this.numOfComment,
      this.isReadMore});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  int _choice = 0;
  String feedbackContent = "";
  int _currentUserId = 0;

  @override
  void initState() {
    // TODO: implement initState
    _loadCounter();
    super.initState();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = (prefs.getInt('accountId') ?? 0);
    });
  }

  checkFeedbackPost(int postId) async {
    FeedbackPost feedback = FeedbackPost();
    int status = await feedback.feedbackPost(
        token: widget.token, postId: postId, content: feedbackContent);
    if (status == 200) {
      setState(() {});
      loadingSuccess(
          status: "Send feedback success !!!\nPlease wait for manager reply.");
      Navigator.of(context).pop();
    } else {
      loadingFail(status: "Can not send feedback:((((");
    }
  }

  void showFeedbackPost(int postId) => showDialog(
      context: context,
      builder: (contest) => Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                title: const Text(
                  "Feedback Post",
                  style: TextStyle(color: Color(0xffDB36A4), fontSize: 26),
                  textAlign: TextAlign.center,
                ),
                content: Stack(
                  overflow: Overflow.visible,
                  children: [
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            maxLines: 5,
                            onChanged: (value) {
                              setState(() {
                                feedbackContent = value.trim();
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: "Enter your feedback",
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Container(
                                    width: 130,
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            Colors.red,
                                          ),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ))),
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Flexible(
                                  child: Container(
                                    width: 130,
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            Colors.lightGreen,
                                          ),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ))),
                                      child: const Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      ),
                                      onPressed: () =>
                                          checkFeedbackPost(postId),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: -40.0,
                      top: -95.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));

  @override
  Widget build(BuildContext context) {
    return _post(
        postId: widget.postId,
        ownerId: widget.ownerId,
        ownerAvatar: widget.ownerAvatar,
        ownerName: widget.ownerName,
        isLikedPost: widget.isLikedPost,
        timePublic: widget.timePublic,
        content: widget.content,
        images: widget.images,
        numOfReact: widget.numOfReact,
        numOfComment: widget.numOfComment,
        isReadMore: widget.isReadMore);
  }

  Widget _post(
      {postId,
        ownerId,
      ownerAvatar,
      ownerName,
      isLikedPost,
      timePublic,
      content,
      List<ImagePost>? images,
      numOfReact,
      numOfComment,
      isReadMore}) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: widget.isPostDetail == false
          ? const EdgeInsets.symmetric(vertical: 5.0)
          : null,
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
                    postId: postId,
                    ownerId: ownerId,
                    ownerAvatar: ownerAvatar,
                    ownerName: ownerName,
                    timePublic: timePublic),
                const SizedBox(
                  height: 4.0,
                ),
                readMoreButton(content, isReadMore),
                images!.isNotEmpty
                    ? const SizedBox.shrink()
                    : const SizedBox(
                        height: 6.0,
                      ),
              ],
            ),
          ),
          images.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GridView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    primary: false,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: imageShow(images, size),
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

  Widget _postHeader({postId, ownerId, ownerAvatar, ownerName, timePublic}) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(timePublic);
    String formattedDate = timeControl(difference);
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfilePage(
                    role: widget.role,
                    token: widget.token,
                    accountId: ownerId,
                  ))),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[200],
            backgroundImage: CachedNetworkImageProvider(ownerAvatar),
          ),
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
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Row(
                children: [
                  Text(
                    formattedDate + " *",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
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
                selectedPopupMenuButton(_choice, postId);
              });
            },
            itemBuilder: (context) =>
                widget.role == 1 || widget.ownerId == _currentUserId
                    ? const [
                        PopupMenuItem(
                          child: Text("Feedback"),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: Text("Delete post"),
                          value: 2,
                        )
                      ]
                    : const [
                        PopupMenuItem(
                          child: Text("Feedback"),
                          value: 1,
                        ),
                      ])
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
                FontAwesomeIcons.solidHeart,
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
        widget.isPostDetail == true ? const Divider() : const SizedBox(),
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
              errorWidget: (context, url, error) => Image.asset(
                'assets/images/img_not_available.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            onTap: () {
              onImageClicked(context, imageUrl, widget.role, widget.token);
            },
          );
        } else {
          // Create the facebook like effect for the last image with number of remaining  images
          return GestureDetector(
            onTap: () => onExpandClicked(
                context, widget.images ?? [], widget.role, widget.token),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/img_not_available.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black54,
                    child: Text(
                      '+' + remaining.toString(),
                      style: const TextStyle(fontSize: 32, color: Colors.white),
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
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/img_not_available.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {
            onImageClicked(context, imageUrl, widget.role, widget.token);
          },
        );
      }
    });
  }

  selectedPopupMenuButton(int value, int postId) async {
    switch (value) {
      case 1:
        showFeedbackPost(postId);
        break;
      case 2:
        DeletePost post = DeletePost();
        int status = await post.deletePost(token: widget.token, postId: postId);
        if (status == 200) {
          widget.isPostDetail == true ? Navigator.of(context).pop() : null;
          setState(() {});
        } else {
          loadingFail(status: "Delete Failed !!!");
        }
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
  }
}
