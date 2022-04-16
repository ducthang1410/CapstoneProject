import 'package:flutter/material.dart';
import 'package:toy_world/apis/gets/get_post_account.dart';
import 'package:toy_world/models/model_image_post.dart';
import 'package:toy_world/models/model_post.dart';
import 'package:toy_world/models/model_post_group.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/widgets/post_widget.dart';

class PostAccountPage extends StatefulWidget {
  int role;
  String token;
  int accountID;

  PostAccountPage(
      {required this.role, required this.token, required this.accountID});

  @override
  State<PostAccountPage> createState() => _PostAccountPageState();
}

class _PostAccountPageState extends State<PostAccountPage> {
  PostGroup? data;
  List<Post>? posts;
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";

  int _limit = 10;
  final int _limitIncrement = 10;

  final ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    listScrollController.addListener(scrollListener);
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
    PostAccountList postAccount = PostAccountList();
    data = await postAccount.getPostAccount(
        token: widget.token, accountId: widget.accountID, size: _limit);
    if (data == null) return List.empty();
    posts = data!.data!.cast<Post>();
    setState(() {});
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          sideAppBar(context, widget.role, widget.token),
          Flexible(
            child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (posts?.length != null) {
                      return ListView.builder(
                          itemCount: posts?.length,
                          padding: EdgeInsets.zero,
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
                              timePublic: posts?[index].publicDate ?? DateTime.now(),
                              content: posts?[index].content ?? "",
                              images: posts?[index].images ?? [],
                              numOfReact: posts?[index].numOfReact ?? 0,
                              numOfComment: posts?[index].numOfComment ?? 0,
                              isReadMore: posts?[index].isReadMore ?? false,
                            );
                          });
                    } else {
                      return const Center(
                          child: Text("There is no posts :(((("));
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          )
        ],
      ),
    );
  }
}
