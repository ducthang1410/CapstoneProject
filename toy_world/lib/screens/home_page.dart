import 'package:flutter/material.dart';
import 'package:toy_world/apis/gets/get_favorite_trading_post.dart';
import 'package:toy_world/models/model_post.dart';
import 'package:toy_world/models/model_trading_post.dart';
import 'package:toy_world/models/model_trading_post_group.dart';
import 'package:toy_world/widgets/post_widget.dart';
import 'package:toy_world/widgets/trading_post_widget.dart';

class HomePage extends StatefulWidget {
  int role;
  String token;

  HomePage({required this.role, required this.token});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TradingPostGroup? data;
  List<TradingPost>? posts;

  int _limit = 10;
  final int _limitIncrement = 10;
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";

  final ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    listScrollController.addListener(scrollListener);
    if (!mounted) return;

    super.initState();
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

  getData() async {
    TradingPostFavoriteList favoriteList = TradingPostFavoriteList();
    data = await favoriteList.getTradingPostFavorite(
        token: widget.token, size: _limit);
    if (data == null) return List.empty();
    posts = data!.data!.cast<TradingPost>();
    setState(() {});
    return posts;
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
                      padding: EdgeInsets.zero,
                      itemCount: posts?.length,
                      controller: listScrollController,
                      itemBuilder: (context, index) {
                        return TradingPostWidget(
                          role: widget.role,
                          token: widget.token,
                          tradingPostId: posts![index].id,
                          isPostDetail: false,
                          ownerId: posts![index].ownerId,
                          ownerAvatar: posts![index].ownerAvatar,
                          ownerName: posts![index].ownerName,
                          isLikedPost: posts![index].isLikedPost,
                          status: posts![index].status,
                          postDate: posts![index].postDate,
                          title: posts![index].title,
                          content: posts?[index].content ?? "",
                          toyName: posts![index].toyName,
                          address: posts?[index].address ?? "",
                          phoneNum: posts![index].phone,
                          exchange: posts?[index].exchange ?? "Money",
                          value: posts![index].value,
                          images: posts?[index].images ?? [],
                          numOfReact: posts![index].noOfReact!.toInt(),
                          numOfComment: posts![index].noOfComment!.toInt(),
                          isReadMore: posts?[index].isReadMore ?? false,
                          isDisable: false,
                        );
                      });
                } else {
                  return const Center(
                      child: Text("There is no posts available:(((("));
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
