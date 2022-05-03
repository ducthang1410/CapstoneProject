import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:toy_world/apis/gets/get_all_proposal.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_proposal.dart';
import 'package:toy_world/widgets/proposal_widget.dart';

class ProposalManagementPage extends StatefulWidget {
  int role;
  String token;

  ProposalManagementPage({required this.role, required this.token});

  @override
  State<ProposalManagementPage> createState() => _ProposalManagementPageState();
}

class _ProposalManagementPageState extends State<ProposalManagementPage> {
  Proposals? data;
  List<Proposal>? proposals;

  int _limit = 10;
  final int _limitIncrement = 10;
  final ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    listScrollController.addListener(scrollListener);
    if (!mounted) return;
    super.initState();
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

  getData() async {
    AllProposalList proposalList = AllProposalList();
    data = await proposalList.getAllProposal(token: widget.token, size: _limit);
    if (data == null) return List.empty();
    proposals = data!.data!.cast<Proposal>();
    setState(() {});
    return proposals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (proposals?.length != null && proposals!.isNotEmpty) {
                return Center(
                  child: ListView.builder(
                      controller: listScrollController,
                      padding: EdgeInsets.zero,
                      itemCount: proposals?.length,
                      itemBuilder: (context, index) {
                        return ProposalWidget(
                            role: widget.role,
                            token: widget.token,
                            proposal: proposals![index]);
                      }),
                );
              } else {
                return const Center(
                    child: Text("There is no proposal available:(((("));
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
