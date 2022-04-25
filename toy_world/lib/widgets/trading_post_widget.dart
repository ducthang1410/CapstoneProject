import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/apis/posts/post_feedback_trading_post.dart';
import 'package:toy_world/apis/puts/put_enable_disable_trading_post.dart';
import 'package:toy_world/apis/puts/put_react_trading_post.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_image_post.dart';
import 'package:toy_world/screens/profile_page.dart';
import 'package:toy_world/screens/trading_chat_page.dart';
import 'package:toy_world/screens/trading_post_detail_page.dart';
import 'package:toy_world/utils/firestore_service.dart';

import 'package:toy_world/utils/helpers.dart';

class TradingPostWidget extends StatefulWidget {
  int role;
  String token;
  int? tradingPostId;
  bool? isPostDetail;
  int? ownerId;
  String? ownerAvatar;
  String? ownerName;
  bool? isLikedPost;
  int? status;
  DateTime? postDate;
  String? title;
  String? toyName;
  String? address;
  String? phoneNum;
  String? exchange;
  double? value;
  String? content;
  List<ImagePost>? images;
  int? numOfReact;
  int? numOfComment;
  bool? isReadMore;
  bool isDisable;

  TradingPostWidget({
    required this.role,
    required this.token,
    required this.tradingPostId,
    required this.isPostDetail,
    required this.ownerId,
    required this.ownerAvatar,
    required this.ownerName,
    required this.isLikedPost,
    required this.status,
    required this.postDate,
    required this.title,
    required this.toyName,
    required this.address,
    required this.phoneNum,
    required this.exchange,
    this.value,
    required this.content,
    this.images,
    this.numOfReact,
    this.numOfComment,
    this.isReadMore,
    required this.isDisable,
  });

  @override
  State<TradingPostWidget> createState() => _TradingPostWidgetState();
}

class _TradingPostWidgetState extends State<TradingPostWidget> {
  int _choice = 0;
  int _currentUserId = 0;
  String _name = "";
  String feedbackContent = "";
  final oCcy = NumberFormat("#,##0", "vi-VN");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = (prefs.getInt('accountId') ?? 0);
      _name = (prefs.getString("name") ?? "");
    });
  }

  checkFeedbackTradingPost(int? tradingPostId) async {
    FeedbackTradingPost feedback = FeedbackTradingPost();
    int status = await feedback.feedbackTradingPost(
        token: widget.token,
        tradingPostId: tradingPostId,
        content: feedbackContent);
    if (status == 200) {
      setState(() {});
      loadingSuccess(
          status: "Send feedback success !!!\nPlease wait for manager reply.");
      Navigator.of(context).pop();
    } else {
      loadingFail(status: "Can not send feedback:((((");
    }
  }

  void showFeedbackPost(int? postId) => showDialog(
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
                                          checkFeedbackTradingPost(postId),
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
        ownerId: widget.ownerId,
        ownerAvatar: widget.ownerAvatar,
        ownerName: widget.ownerName,
        isLikedPost: widget.isLikedPost,
        postDate: widget.postDate,
        title: widget.title,
        toyName: widget.toyName,
        content: widget.content,
        exchange: widget.exchange,
        value: widget.value,
        address: widget.address,
        phoneNum: widget.phoneNum,
        images: widget.images,
        numOfReact: widget.numOfReact,
        numOfComment: widget.numOfComment,
        isReadMore: widget.isReadMore);
  }

  Widget _post(
      {ownerAvatar,
      ownerId,
      ownerName,
      title,
      toyName,
      address,
      exchange,
      value,
      phoneNum,
      isLikedPost,
      postDate,
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
                    ownerId: ownerId,
                    ownerAvatar: ownerAvatar,
                    ownerName: ownerName,
                    timePublic: postDate),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                readMoreButton(content, isReadMore),
                const Divider(),
                const SizedBox(
                  height: 4.0,
                ),
                _buildInfo(
                    const Icon(
                      Icons.toys,
                      color: Color(0xffDB36A4),
                    ),
                    toyName),
                const SizedBox(
                  height: 4.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Exchange: ",
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          exchange,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    value != null && value != 0
                        ? _buildInfo(
                            const Icon(
                              Icons.money,
                              color: Colors.teal,
                            ),
                            oCcy.format(value).toString() + " VND")
                        : const SizedBox.shrink(),
                  ],
                ),
                const SizedBox(
                  height: 4.0,
                ),
                _buildInfo(
                    const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    address),
                const SizedBox(
                  height: 4.0,
                ),
                _buildInfo(
                    const Icon(
                      Icons.phone,
                      color: Colors.green,
                    ),
                    phoneNum),
                const SizedBox(
                  height: 4.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Status: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    showStatusTradingPost(widget.status),
                  ],
                ),
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
                  padding: const EdgeInsets.only(top: 8.0),
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
          _currentUserId != widget.ownerId
              ? widget.status == 0
                  ? _buildContact()
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
          widget.isDisable == false
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0),
                  child: _postStats(
                      isLikedPost: isLikedPost,
                      numOfReact: numOfReact ?? 0,
                      numOfComment: numOfComment ?? 0),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _postHeader({ownerId, ownerAvatar, ownerName, timePublic}) {
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
        widget.isDisable == false
            ? PopupMenuButton(
                icon: const Icon(Icons.more_horiz),
                onSelected: (int value) {
                  setState(() {
                    _choice = value;
                    selectedPopupMenuButton(_choice);
                  });
                },
                itemBuilder: (context) => widget.ownerId == _currentUserId
                    ? const [
                        PopupMenuItem(
                          child: Text("Feedback"),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: Text("Delete Post"),
                          value: 3,
                        )
                      ]
                    : widget.role == 1
                        ? const [
                            PopupMenuItem(
                              child: Text("Feedback"),
                              value: 1,
                            ),
                            PopupMenuItem(
                              child: Text("Delete Post"),
                              value: 3,
                            )
                          ]
                        : const [
                            PopupMenuItem(
                              child: Text("Feedback"),
                              value: 1,
                            ),
                          ])
            : ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xffDB36A4),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                child: const Text(
                  "Enable",
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                onPressed: () {
                  enableTradingPost(
                      token: widget.token, tradingPostId: widget.tradingPostId);
                },
              ),
      ],
    );
  }

  Widget _buildContact() {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Contact Owner",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () async {
              await createTradingConversation(
                  widget.title,
                  widget.tradingPostId,
                  widget.toyName,
                  _currentUserId,
                  widget.ownerId,
                  widget.content,
                  _name);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TradingChatPage(
                    arguments: TradingChatPageArguments(
                      role: widget.role,
                      token: widget.token,
                      currentUserId: _currentUserId,
                      peerId: widget.ownerId,
                      sellerId: widget.ownerId,
                      buyerId: _currentUserId,
                      tradingPostId: widget.tradingPostId,
                      toyName: widget.toyName,
                      exchangeWith: widget.exchange,
                      value: widget.value,
                      buyerName: _name,
                      title: widget.title ?? "",
                    ),
                  ),
                ),
              );
            },
            child: Container(
              alignment: Alignment.center,
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                    width: 1, style: BorderStyle.solid, color: Colors.black87),
              ),
              child: Row(
                children: const [
                  Icon(FontAwesomeIcons.commentDots),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Chat",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
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
                    fontSize: 16,
                    color: isLikedPost ? Colors.red : Colors.grey[600],
                    fontWeight: isLikedPost ? FontWeight.bold : null,
                  ),
                ),
                onTap: () => {
                      reactTradingPost(
                          token: widget.token,
                          tradingPostId: widget.tradingPostId),
                    }),
            _postButton(
              Icon(
                FontAwesomeIcons.comment,
                color: Colors.grey[600],
                size: 20,
              ),
              const Text("Comment" , style: TextStyle(fontSize: 16),),
              onTap: () => widget.isPostDetail == false
                  ? Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TradingPostDetailPage(
                            role: widget.role,
                            token: widget.token,
                            tradingPostID: widget.tradingPostId,
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
                      style: const TextStyle(fontSize: 32),
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

  selectedPopupMenuButton(int value) async {
    switch (value) {
      case 1:
        showFeedbackPost(widget.tradingPostId);
        break;
      case 2:
        print(value);
        break;
      case 3:
        EnableDisableTradingPost enable = EnableDisableTradingPost();
        int status = await enable.enableOrDisableTradingPost(
            token: widget.token,
            tradingPostId: widget.tradingPostId,
            choice: 0);
        if (status == 200) {
          loadingSuccess(status: "Success");

          widget.isPostDetail == true ? Navigator.of(context).pop() : null;
          setState(() {});
        } else {
          loadingFail(status: "Failed !!!");
        }
        break;
    }
  }

  reactTradingPost({token, tradingPostId}) async {
    ReactTradingPost react = ReactTradingPost();
    int status = await react.reactTradingPost(
        token: token, tradingPostId: tradingPostId);
    if (status == 200) {
      setState(() {});
    } else {
      loadingFail(status: "Love Failed !!!");
    }
  }

  enableTradingPost({token, tradingPostId}) async {
    EnableDisableTradingPost enable = EnableDisableTradingPost();
    int status = await enable.enableOrDisableTradingPost(
        token: token, tradingPostId: tradingPostId, choice: 1);
    if (status == 200) {
      setState(() {});
      loadingSuccess(status: "Enable Success");
    } else {
      loadingFail(status: "Enable Failed !!!");
    }
  }

  Widget _buildInfo(Icon icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        icon,
        const SizedBox(
          width: 8.0,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 16),
          maxLines: 2,
        ),
      ],
    );
  }
}
