import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:toy_world/apis/gets/get_disable_trading_post.dart';
import 'package:toy_world/models/model_image_post.dart';
import 'package:toy_world/models/model_trading_post.dart';
import 'package:toy_world/models/model_trading_post_group.dart';
import 'package:toy_world/widgets/trading_post_widget.dart';

class DisableTradingPostPage extends StatefulWidget {
  int role;
  String token;

  DisableTradingPostPage({
    required this.role,
    required this.token,
  });

  @override
  State<DisableTradingPostPage> createState() => _DisableTradingPostPageState();
}

class _DisableTradingPostPageState extends State<DisableTradingPostPage> {
  TradingPostGroup? data;
  List<TradingPost>? posts;
  List<ImagePost>? images;
  int _limit = 10;
  final int _limitIncrement = 10;
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";

  final ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    listScrollController.addListener(scrollListener);
    super.initState();
  }

  getData() async {
    DisableTradingPostList disablePost = DisableTradingPostList();
    data = await disablePost.getDisableTradingPost(
        token: widget.token, size: _limit);
    if (data == null) return List.empty();
    posts = data!.data!.cast<TradingPost>();
    setState(() {});
    return posts;
  }

  void scrollListener() {
    if (listScrollController.offset >=
        listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (posts?.length != null && posts!.isNotEmpty) {
                return ListView.builder(
                    controller: listScrollController,
                    padding: EdgeInsets.zero,
                    itemCount: posts?.length,
                    itemBuilder: (context, index) {
                      images = posts![index].images!.cast<ImagePost>();
                      return TradingPostWidget(
                        role: widget.role,
                        token: widget.token,
                        tradingPostId: posts![index].id,
                        isPostDetail: false,
                        ownerId: posts![index].ownerId,
                        ownerAvatar: posts?[index].ownerAvatar ?? _avatar,
                        ownerName: posts![index].ownerName,
                        isLikedPost: posts![index].isLikedPost,
                        status: posts![index].status,
                        postDate: posts![index].postDate,
                        title: posts![index].title,
                        content: posts![index].content,
                        toyName: posts![index].toyName,
                        address: posts![index].address,
                        phoneNum: posts![index].phone,
                        exchange: posts![index].exchange,
                        value: posts![index].value,
                        images: images,
                        numOfReact: posts![index].noOfReact!.toInt(),
                        numOfComment: posts![index].noOfComment!.toInt(),
                        isReadMore: posts?[index].isReadMore ?? false,
                        isDisable: true,
                      );
                    });
              } else {
                return const Center(
                    child: Text("There is no post available :(((("));
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
