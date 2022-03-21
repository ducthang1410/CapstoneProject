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

  PostAccountPage({required this.role, required this.token, required this.accountID});

  @override
  State<PostAccountPage> createState() => _PostAccountPageState();
}

class _PostAccountPageState extends State<PostAccountPage> {
  PostGroup? data;
  List<Post>? posts;
  List<ImagePost>? images;
  int size = 10;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    PostAccountList postAccount = PostAccountList();
    data = await postAccount.getPostAccount(
        token: widget.token, accountId: widget.accountID, size: size);
    if (data == null) return List.empty();
    posts = data!.data!.cast<Post>();
    setState(() {});
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          sideAppBar(context),
          Expanded(
            child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (posts?.length != null) {
                      return ListView.builder(
                          itemCount: posts?.length,
                          itemBuilder: (context, index) {
                            images = posts![index].images!.cast<ImagePost>();
                            return PostWidget(
                                role: widget.role,
                                token: widget.token,
                                postId: posts![index].id,
                                isPostDetail: false,
                                ownerAvatar: posts![index].ownerAvatar,
                                ownerName: posts![index].ownerName,
                                isLikedPost: posts![index].isLikedPost,
                                timePublic: posts![index].publicDate,
                                content: posts![index].content,
                                images: images,
                                numOfReact: posts![index].numOfReact!.toInt(),
                                numOfComment:
                                posts![index].numOfComment!.toInt());
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
