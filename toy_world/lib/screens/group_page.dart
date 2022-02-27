import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toy_world/apis/gets/get_post_group.dart';
import 'package:toy_world/components/component.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:toy_world/models/model_post.dart';
import 'package:toy_world/models/model_post_group.dart';

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
      body: Column(
        children: [
          sideAppBar(context),
          Expanded(
            child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                  if(snapshot.hasData) {
                  if(posts?.length != null){
                    return ListView.builder(
                        itemCount: posts?.length,
                        itemBuilder: (context, index) {
                        return _post(
                            imgAvatar: posts![index].ownerAvatar,
                            ownerName: posts![index].ownerName,
                            timePublic: posts![index].publicDate,
                            content: posts![index].content,
                            image: posts![index].ownerAvatar,
                            numOfReact: posts![index].numOfReact!.toInt(),
                            numOfComment: posts![index].numOfComment!.toInt()
                        );
                    });
                  } else {
                    return const Center(
                        child: Text("There is no posts :((((")
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            ),
          )
        ],
      ),
    );
  }

  Widget _post({imgAvatar, ownerName, timePublic, content, image, numOfReact, numOfComment}) {
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
                image != null
                    ? const SizedBox.shrink()
                    : const SizedBox(
                        height: 6.0,
                      ),
              ],
            ),
          ),
          image != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CachedNetworkImage(
                    imageUrl: image,
                  ))
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: _postStats(numOfReact: numOfReact, numOfComment: numOfComment),
          )
        ],
      ),
    );
  }

  Widget _postHeader({imgAvatar, ownerName, timePublic}) {
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
                    timePublic + " * ",
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
              onTap: () => print("Comment"),
            )
          ],
        )
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
