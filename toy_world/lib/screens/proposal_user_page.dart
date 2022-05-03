import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:toy_world/apis/gets/get_user_proposal.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_proposal.dart';
import 'package:toy_world/screens/new_proposal_page.dart';
import 'package:toy_world/widgets/proposal_widget.dart';

class ProposalUserPage extends StatefulWidget {
  int role;
  String token;
  int accountId;

  ProposalUserPage(
      {required this.role, required this.token, required this.accountId});

  @override
  State<ProposalUserPage> createState() => _ProposalUserPageState();
}

class _ProposalUserPageState extends State<ProposalUserPage> {
  List<Proposal>? proposals;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    if (!mounted) return;
    super.initState();
  }

  getData() async {
    UserProposal userProposal = UserProposal();
    proposals = await userProposal.getUserProposal(
        token: widget.token, accountId: widget.accountId);
    if (proposals == null) return List.empty();
    setState(() {});
    return proposals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffDB36A4),
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        body: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (proposals?.length != null && proposals!.isNotEmpty) {
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: proposals?.length,
                      itemBuilder: (context, index) {
                        return ProposalWidget(
                            role: widget.role,
                            token: widget.token,
                            proposal: proposals![index]
                        );
                      });
                } else {
                  return const Center(
                      child: Text("There is no proposal available:(((("));
                }
              }
              return const Center(
                  child: Text("There is no proposal available:(((("));
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xffDB36A4),
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NewProposalPage(
                  role: widget.role,
                  token: widget.token,
                )));
          },
        ));
  }
}
