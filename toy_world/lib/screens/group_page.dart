import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:toy_world/components/component.dart';
import 'package:toy_world/screens/contest_group_page.dart';
import 'package:toy_world/screens/post_page.dart';
import 'package:toy_world/screens/trading_post_page.dart';

class GroupPage extends StatefulWidget {
  int role;
  String token;
  int groupID;
  String coverImage;

  GroupPage({required this.role, required this.token, required this.groupID, required this.coverImage});

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  int _limit = 5;
  final int _limitIncrement = 5;

  final ScrollController _parentScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _parentScrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void scrollListener() {
    if (_parentScrollController.offset >=
        _parentScrollController.position.maxScrollExtent &&
        !_parentScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return NestedScrollView(
        controller: _parentScrollController,
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.coverImage,
                    width: size.width,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/img_not_available.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  groupAppBar(context, widget.role, widget.token),
                ],
              ),
            ),
          ];
        },
        body: DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.07,
                child: const TabBar(
                  labelColor: Color(0xffDB36A4),
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Color(0xffDB36A4),
                  tabs: [
                    Tab(
                      child: Text(
                        "Post",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Trading",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Contest",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    PostPage(
                      role: widget.role,
                      token: widget.token,
                      groupID: widget.groupID,
                      limit: _limit,
                    ),
                    TradingPostPage(
                      role: widget.role,
                      token: widget.token,
                      groupID: widget.groupID,
                      limit: _limit,
                    ),
                    ContestGroupPage(
                      role: widget.role,
                      token: widget.token,
                      groupID: widget.groupID,
                      limit: _limit,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
