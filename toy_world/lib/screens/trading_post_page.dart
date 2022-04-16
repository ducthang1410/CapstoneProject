import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/apis/gets/get_trading_post_group.dart';

import 'package:toy_world/models/model_trading_post.dart';
import 'package:toy_world/models/model_trading_post_group.dart';
import 'package:toy_world/widgets/create_trading_post_widget.dart';
import 'package:toy_world/widgets/trading_post_widget.dart';

class TradingPostPage extends StatefulWidget {
  int role;
  String token;
  int groupID;
  int limit;

  TradingPostPage(
      {required this.role,
      required this.token,
      required this.groupID,
      required this.limit});

  @override
  State<TradingPostPage> createState() => _TradingPostPageState();
}

class _TradingPostPageState extends State<TradingPostPage> {
  TradingPostGroup? data;
  List<TradingPost>? posts;


  List<Asset> imagesPicker = <Asset>[];
  String _error = 'No Error Dectected';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    TradingPostGroupList postGroup = TradingPostGroupList();
    data = await postGroup.getTradingPostGroup(
        token: widget.token, groupId: widget.groupID, size: widget.limit);
    if (data == null) return List.empty();
    posts = data!.data!.cast<TradingPost>();
    setState(() {});
    return posts;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[400],
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Column(
            children: [
              _newTradingPost(),
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
                          shrinkWrap: true,
                          primary: false,
                          itemCount: posts?.length,
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
                              content: posts![index].content,
                              toyName: posts![index].toyName,
                              address: posts![index].address,
                              phoneNum: posts![index].phone,
                              exchange: posts![index].exchange,
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
                          child: Text("There is no post available :(((("));
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

  Widget _newTradingPost() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
      color: Colors.grey.shade200,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create your post to trading with others",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 8.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xffDB36A4)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ))),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateTradingPostWidget(
                              token: widget.token,
                              groupID: widget.groupID,
                              role: widget.role,
                            )));
                  },
                  child: const Text(
                    'Create',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
            )
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
