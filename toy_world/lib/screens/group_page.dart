import 'package:flutter/material.dart';
import 'package:toy_world/apis/gets/get_post_group.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_post.dart';
import 'package:toy_world/models/model_post_group.dart';
import 'package:toy_world/widgets/post_widget.dart';


class GroupPage extends StatefulWidget {
  int role;
  String token;
  int groupID;

  GroupPage({required this.role, required this.token, required this.groupID});

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  PostGroup? data;
  List<Post>? posts;
  int size = 10;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    PostGroupList postGroup = PostGroupList();
    data = await postGroup.getPostGroup(
        token: widget.token, groupId: widget.groupID, size: size);
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
                            return PostWidget(
                              role: widget.role,
                                token: widget.token,
                                postId: posts![index].id,
                                isPostDetail: false,
                                imgAvatar: posts![index].ownerAvatar,
                                ownerName: posts![index].ownerName,
                                timePublic: posts![index].publicDate,
                                content: posts![index].content,
                                images: posts![index].ownerAvatar,
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
