import 'package:flutter/material.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/screens/disable_trading_post_page.dart';
import 'package:toy_world/screens/proposal_list_page.dart';

class ManagementPage extends StatefulWidget {
  int role;
  String token;

  ManagementPage({required this.role, required this.token});

  @override
  State<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          sideAppBar(context, widget.role, widget.token),
          Expanded(
            child: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.07,
                      child: const TabBar(
                        labelColor: Color(0xffDB36A4),
                        unselectedLabelColor: Colors.black,
                        indicatorColor: Color(0xffDB36A4),
                        isScrollable: true,
                        tabs: [
                          Tab(
                            child: Text(
                              "Disabled Trading Post",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Proposal",
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
                        DisableTradingPostPage(
                          token: widget.token,
                          role: widget.role,
                        ),
                        ProposalListPage(
                            role: widget.role, token: widget.token),
                      ],
                    ))
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
