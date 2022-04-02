
import "package:flutter/material.dart";

import 'package:toy_world/widgets/message_widget.dart';
import 'package:toy_world/widgets/trading_message_widget.dart';

class MessageListPage extends StatefulWidget {
  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffDB36A4),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: DefaultTabController(
        length: 2,
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
                  Tab(
                      child: Text(
                    "Messages",
                    style: TextStyle(fontSize: 16),
                  )),
                  Tab(
                      child: Text(
                    "Tradings",
                    style: TextStyle(fontSize: 16),
                  )),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  MessageWidget(),
                  TradingMessageWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
