import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:toy_world/apis/gets/get_disable_trading_post.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_choice.dart';
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

  int _limit = 10;
  final int _limitIncrement = 10;
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";

  final ScrollController listScrollController = ScrollController();

  List<Choice> items = <Choice>[
    Choice(id: 0, name: "All"),
    Choice(id: 1, name: "Disable"),
    Choice(id: 2, name: "Enable")
  ];
  Choice? selectedItem = Choice(id: 0, name: "All");

  @override
  void initState() {
    // TODO: implement initState
    listScrollController.addListener(scrollListener);
    super.initState();
  }

  getData() async {
    DisableTradingPostList disablePost = DisableTradingPostList();
    data = await disablePost.getDisableTradingPost(
        token: widget.token, status: selectedItem!.id, size: _limit);
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
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5.0, right: 10.0),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: SizedBox(
              height: 60.0,
              width: 150.0,
              child: DropdownButtonFormField<Choice>(
                isExpanded: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(width: 3, color: Color(0xffDB36A4))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(width: 3, color: Color(0xffDB36A4))),
                ),
                onChanged: (Choice? newValue) {
                  setState(() {
                    selectedItem = newValue;
                  });
                },
                value: items[0],
                elevation: 16,
                items: items.map<DropdownMenuItem<Choice>>((Choice value) {
                  return DropdownMenuItem<Choice>(
                    value: value,
                    child: Center(child: Text(value.name)),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (posts?.length != null && posts!.isNotEmpty) {
                      return ListView.builder(
                          controller: listScrollController,
                          padding: EdgeInsets.zero,
                          itemCount: posts?.length,
                          itemBuilder: (context, index) {
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
                              exchange: posts?[index].exchange ?? "",
                              value: posts![index].value,
                              images: posts?[index].images ?? [],
                              numOfReact: posts![index].noOfReact!.toInt(),
                              numOfComment: posts![index].noOfComment!.toInt(),
                              isReadMore: posts?[index].isReadMore ?? false,
                              isDisable: posts?[index].isDisabled ?? false,
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
          ),
        ],
      ),
    );
  }
}
