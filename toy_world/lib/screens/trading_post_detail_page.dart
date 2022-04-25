import 'package:flutter/material.dart';
import 'package:toy_world/apis/gets/get_trading_post_detail.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_image_post.dart';
import 'package:toy_world/widgets/comment_widget.dart';
import 'package:toy_world/widgets/trading_post_widget.dart';

import '../models/model_comment.dart';
import '../models/model_trading_post_detail.dart';

class TradingPostDetailPage extends StatefulWidget {
  int role;
  String token;
  int? tradingPostID;

  TradingPostDetailPage({required this.role, required this.token, required this.tradingPostID});

  @override
  State<TradingPostDetailPage> createState() => _TradingPostDetailPageState();
}

class _TradingPostDetailPageState extends State<TradingPostDetailPage> {
  TradingPostDetail? data;
  List<Comment>? comments;
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";

  getData() async {
    TradingPostDetailData detail = TradingPostDetailData();
    data = await detail.getTradingPostDetail(
        token: widget.token, tradingPostId: widget.tradingPostID);
    if (data == null) return List.empty();
    comments = data!.comment!.cast<Comment>();
    setState(() {});
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            sideAppBar(context, widget.role, widget.token),
            FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  return data != null
                      ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TradingPostWidget(
                        role: widget.role,
                        token: widget.token,
                        tradingPostId: data!.id,
                        isPostDetail: true,
                        ownerId: data!.ownerId,
                        ownerAvatar: data?.ownerAvatar ?? _avatar,
                        ownerName: data?.ownerName ?? "Name",
                        isLikedPost: data?.isReact ?? false,
                        status: data!.status,
                        postDate: data?.postDate ?? DateTime.now(),
                        title: data!.title,
                        content: data!.content,
                        toyName: data?.toyName ?? "",
                        address: data?.address ?? "Unknown",
                        phoneNum: data?.phone ?? "Unknown",
                        exchange: data?.trading ?? "",
                        value: data?.value,
                        images: data?.images ?? [],
                        numOfReact: data?.numOfReact?.toInt() ?? 0,
                        numOfComment: data?.numOfComment?.toInt() ?? 0,
                        isReadMore: data?.isReadMore ?? false,
                        isDisable: false,
                      ),
                      CommentWidget(
                        role: widget.role,
                        token: widget.token,
                        postID: widget.tradingPostID,
                        ownerPostId: data!.ownerId,
                        comments: comments ?? [],
                        type: "TradingPost",
                      ),
                    ],
                  )
                      : const Center(
                    child: CircularProgressIndicator(),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
