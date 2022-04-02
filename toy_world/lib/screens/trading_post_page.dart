import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/apis/gets/get_trading_post_group.dart';
import 'package:toy_world/models/model_image_post.dart';
import 'package:toy_world/models/model_trading_post.dart';
import 'package:toy_world/models/model_trading_post_group.dart';
import 'package:toy_world/widgets/trading_post_widget.dart';

class TradingPostPage extends StatefulWidget {
  int role;
  String token;
  int groupID;

  TradingPostPage(
      {required this.role, required this.token, required this.groupID});

  @override
  State<TradingPostPage> createState() => _TradingPostPageState();
}

class _TradingPostPageState extends State<TradingPostPage> {
  TradingPostGroup? data;
  List<TradingPost>? posts;
  List<ImagePost>? images;
  int _limit = 10;
  final int _limitIncrement = 10;
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";
  late TextEditingController controller;
  final ScrollController listScrollController = ScrollController();
  List<Asset> imagesPicker = <Asset>[];
  String _error = 'No Error Dectected';

  @override
  void initState() {
    // TODO: implement initState
    _loadCounter();
    listScrollController.addListener(scrollListener);
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
    TradingPostGroupList postGroup = TradingPostGroupList();
    data = await postGroup.getTradingPostGroup(
        token: widget.token, groupId: widget.groupID, size: _limit);
    if (data == null) return List.empty();
    posts = data!.data!.cast<TradingPost>();
    setState(() {});
    return posts;
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatar = (prefs.getString('avatar') ?? "");
    });
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
      body: Column(mainAxisSize: MainAxisSize.min, children: [
        // _newPost(),
        Expanded(
          child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (posts?.length != null) {
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
                              ownerAvatar: posts![index].ownerAvatar,
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
                              numOfComment: posts![index].noOfComment!.toInt());
                        });
                  } else {
                    return const Center(child: Text("There is no posts :(((("));
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        )
      ]),
    );
  }

  // Widget _newPost() {
  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
  //     color: Colors.white,
  //     child: SafeArea(
  //       child: Column(
  //         children: [
  //           Row(
  //             children: [
  //               CircleAvatar(
  //                 radius: 20,
  //                 backgroundColor: Colors.grey[200],
  //                 backgroundImage: CachedNetworkImageProvider(_avatar),
  //               ),
  //               const SizedBox(width: 8.0),
  //               Expanded(
  //                 child: TextField(
  //                   controller: controller,
  //                   decoration: const InputDecoration.collapsed(
  //                     hintText: 'What\'s on your mind?',
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //           const Divider(height: 10.0, thickness: 0.5),
  //           SizedBox(
  //             height: 40,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 IconButton(
  //                   onPressed: loadAssets,
  //                   icon: const Icon(
  //                     Icons.photo_library,
  //                     color: Color(0xffDB36A4),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 16.0),
  //                 ElevatedButton(
  //                     style: ButtonStyle(
  //                         backgroundColor: MaterialStateProperty.all(
  //                             const Color(0xffDB36A4)),
  //                         shape:
  //                         MaterialStateProperty.all<RoundedRectangleBorder>(
  //                             RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10.0),
  //                             ))),
  //                     onPressed: () async {
  //                       try {
  //                         List<String> imageUrls;
  //                         imageUrls = uploadImages(imagesPicker);
  //                         if (await checkNewPost(
  //                           token: widget.token,
  //                           groupId: widget.groupID,
  //                           content: controller.text,
  //                           imagesLink: imageUrls,
  //                         ) ==
  //                             200) {
  //                           imagesPicker.clear();
  //                           controller.clear();
  //                           setState(() {});
  //                         } else {
  //                           loadingFail(
  //                               status:
  //                               "Create Post Failed - ${await checkNewPost(token: widget.token, groupId: widget.groupID, content: controller.text)}");
  //                         }
  //                       } catch (e) {
  //                         loadingFail(status: "Create Post Failed !!! \n $e");
  //                       }
  //                     },
  //                     child: const Text(
  //                       'Post',
  //                       style: TextStyle(fontSize: 20, color: Colors.white),
  //                     ))
  //               ],
  //             ),
  //           ),
  //           imagesPicker.isNotEmpty
  //               ? buildGridViewImagePicker()
  //               : const SizedBox.shrink(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
                      imagesPicker!.removeAt(index);
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

  // checkNewPost({token, groupId, content, List<String>? imagesLink}) async {
  //   NewPost post = NewPost();
  //   var status = await post.newPost(
  //       token: token, groupId: groupId, content: content, imgLink: imagesLink);
  //   return status;
  // }
  //
  // Future<void> loadAssets() async {
  //   List<Asset> resultList = <Asset>[];
  //   String error = 'No Error Detected';
  //
  //   try {
  //     resultList = await MultiImagePicker.pickImages(
  //       maxImages: 100,
  //       enableCamera: true,
  //       selectedAssets: imagesPicker,
  //       cupertinoOptions: const CupertinoOptions(
  //         takePhotoIcon: "chat",
  //         doneButtonTitle: "Fatto",
  //       ),
  //       materialOptions: const MaterialOptions(
  //         actionBarColor: "#abcdef",
  //         actionBarTitle: "Select Photo",
  //         allViewTitle: "All Photos",
  //         useDetailsView: false,
  //         selectCircleStrokeColor: "#000000",
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     error = e.toString();
  //   }
  //   if (!mounted) return;
  //
  //   setState(() {
  //     imagesPicker = resultList;
  //     _error = error;
  //   });
  // }
}
