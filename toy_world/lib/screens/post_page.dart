import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/apis/gets/get_image_post.dart';
import 'package:toy_world/apis/gets/get_num_of_comment.dart';
import 'package:toy_world/apis/gets/get_post_group.dart';
import 'package:toy_world/apis/posts/post_new_post.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_post.dart';
import 'package:toy_world/models/model_post_group.dart';
import 'package:toy_world/utils/helpers.dart';
import 'package:toy_world/widgets/post_widget.dart';

class PostPage extends StatefulWidget {
  int role;
  String token;
  int groupID;
  int limit;

  PostPage(
      {required this.role,
      required this.token,
      required this.groupID,
      required this.limit});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  PostGroup? data;
  List<Post>? posts;
  // int? numOfComment;
  //
  // List<ImagePost>? images;

  // int _limit = 10;
  // final int _limitIncrement = 10;
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";

  late TextEditingController controller;
  // final ScrollController listScrollController = ScrollController();

  List<Asset> imagesPicker = <Asset>[];
  String _error = 'No Error Dectected';

  @override
  void initState() {
    // TODO: implement initState
    _loadCounter();
    // listScrollController.addListener(scrollListener);
    if (!mounted) return;
    controller = TextEditingController()
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  getData() async {
    PostGroupList postGroup = PostGroupList();
    data = await postGroup.getPostGroup(
        token: widget.token, groupId: widget.groupID, size: widget.limit);
    if (data == null) return List.empty();
    posts = data!.data!.cast<Post>();
    setState(() {});
    return posts;
  }

  // getNumOfComment(int? postId) async {
  //   NumOfComment num = NumOfComment();
  //   numOfComment =
  //       await num.getNumOfComment(token: widget.token, postId: postId);
  //   getImagePost(postId);
  //   if (!mounted) return;
  //   setState(() {});
  // }
  //
  // getImagePost(int? postId) async {
  //   ImagePostList imagePostList = ImagePostList();
  //   images = await imagePostList.getImagePostList(
  //       token: widget.token, postId: postId);
  // }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatar = (prefs.getString('avatar') ?? "");
    });
  }

  // void scrollListener() {
  //   if (listScrollController.offset >=
  //           listScrollController.position.maxScrollExtent &&
  //       !listScrollController.position.outOfRange) {
  //     setState(() {
  //       _limit += _limitIncrement;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: SingleChildScrollView(
        // controller: listScrollController,
        physics: const NeverScrollableScrollPhysics(),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Column(
            children: [
              _newPost(),
              const SizedBox(
                height: 6,
              ),
            ],
          ),
          Flexible(
            child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (posts?.length != null && posts!.isNotEmpty) {
                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: posts?.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            // getNumOfComment(posts![index].id).then((value) {
                            //   posts![index].numOfComment = value;
                            // });
                            // numOfComment = posts![index].numOfComment;
                            // getImagePost(posts![index].id).then((value) {
                            //   posts![index].images = value;
                            //   images = posts![index].images;
                            // });
                            // posts![index].numOfComment = getNumOfComment(posts![index].id);
                            // posts![index].images = getImagePost(posts![index].id);
                            return PostWidget(
                              role: widget.role,
                              token: widget.token,
                              postId: posts![index].id,
                              isPostDetail: false,
                              ownerId: posts![index].ownerId,
                              ownerAvatar: posts![index].ownerAvatar,
                              ownerName: posts![index].ownerName,
                              isLikedPost: posts![index].isLikedPost,
                              timePublic: posts![index].publicDate,
                              content: posts![index].content,
                              images: posts?[index].images ?? [],
                              numOfReact: posts![index].numOfReact!.toInt(),
                              numOfComment: posts![index].numOfComment ?? 0,
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
                }),
          )
        ]),
      ),
    );
  }

  Widget _newPost() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: CachedNetworkImageProvider(_avatar),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'What\'s on your mind?',
                    ),
                  ),
                )
              ],
            ),
            const Divider(height: 10.0, thickness: 0.5),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: loadAssets,
                    icon: const Icon(
                      Icons.photo_library,
                      color: Color(0xffDB36A4),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xffDB36A4)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                      onPressed: () async {
                        try {
                          List<String> imageUrls;
                          imageUrls = await uploadImages(imagesPicker, "Post");
                          if (await checkNewPost(
                                  token: widget.token,
                                  groupId: widget.groupID,
                                  content: controller.text,
                                  imagesLink: imageUrls) ==
                              200) {
                            setState(() {
                              imagesPicker.clear();
                              controller.clear();
                            });
                            loadingSuccess(
                                status:
                                    "Post success!!!\nPlease wait for approval.");
                          } else {
                            loadingFail(
                                status:
                                    "Create Post Failed - ${await checkNewPost(token: widget.token, groupId: widget.groupID, content: controller.text)}");
                          }
                        } catch (e) {
                          loadingFail(status: "Create Post Failed !!! \n $e");
                        }
                      },
                      child: const Text(
                        'Post',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ))
                ],
              ),
            ),
            imagesPicker.isNotEmpty
                ? buildGridViewImagePicker()
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget buildGridViewImagePicker() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 6,
      children: List.generate(imagesPicker.length, (index) {
        Asset asset = imagesPicker[index];
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              ),
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  color: const Color.fromRGBO(255, 255, 244, 0.2),
                  child: IconButton(
                    onPressed: () {
                      imagesPicker.removeAt(index);
                      setState(() {});
                    },
                    icon: const Icon(Icons.delete),
                    color: Colors.black87,
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  checkNewPost({token, groupId, content, List<String>? imagesLink}) async {
    NewPost post = NewPost();
    var status = await post.newPost(
        token: token, groupId: groupId, content: content, imgLink: imagesLink);
    return status;
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 100,
        enableCamera: true,
        selectedAssets: imagesPicker,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Select Photo",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      imagesPicker = resultList;
      _error = error;
    });
  }
}
