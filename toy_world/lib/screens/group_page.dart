import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:toy_world/components/component.dart';
import 'package:toy_world/screens/contest_page.dart';
import 'package:toy_world/screens/post_page.dart';
import 'package:toy_world/screens/trading_post_page.dart';

class GroupPage extends StatefulWidget {
  int role;
  String token;
  int groupID;

  GroupPage({required this.role, required this.token, required this.groupID});

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/toyType3.jpg",
                    width: size.width,
                    fit: BoxFit.cover,
                  ),
                  groupAppBar(context),
                ],
              ),
            ),
          ];
        },
        body: DefaultTabController(
          length: 4,
          initialIndex: 0,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.06,
                child: const TabBar(
                  labelColor: Color(0xffDB36A4),
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Color(0xffDB36A4),
                  tabs: [
                    Tab(text: 'Post'),
                    Tab(text: 'Trading'),
                    Tab(text: 'Contest'),
                    Tab(text: 'Proposal'),
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
                    ),
                    TradingPostPage(
                      role: widget.role,
                      token: widget.token,
                      groupID: widget.groupID,
                    ),
                    const ContestPage(),
                    const ContestPage(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
