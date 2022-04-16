import 'package:flutter/material.dart';
import 'package:toy_world/apis/gets/get_popular_post.dart';
import 'package:toy_world/models/model_post.dart';
import 'package:toy_world/models/model_post_group.dart';
import 'package:toy_world/widgets/post_widget.dart';

class HomePage extends StatefulWidget {
  int role;
  String token;

  HomePage({required this.role, required this.token});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PostGroup? data;
  List<Post>? posts;

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
    PopularPostList popularPosts = PopularPostList();
    data = await popularPosts.getPopularPost(token: widget.token, size: _limit);
    if (data == null) return List.empty();
    posts = data!.data!.cast<Post>();
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
                        return PostWidget(
                          role: widget.role,
                          token: widget.token,
                          postId: posts![index].id,
                          isPostDetail: false,
                          ownerId: posts![index].ownerId,
                          ownerAvatar: posts?[index].ownerAvatar ?? _avatar,
                          ownerName: posts?[index].ownerName ?? "Name",
                          isLikedPost: posts?[index].isLikedPost ?? false,
                          timePublic:
                              posts?[index].publicDate ?? DateTime.now(),
                          content: posts?[index].content ?? "",
                          images: posts?[index].images ?? [],
                          numOfReact: posts?[index].numOfReact ?? 0,
                          numOfComment: posts?[index].numOfComment ?? 0,
                          isReadMore: posts?[index].isReadMore ?? false,
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
