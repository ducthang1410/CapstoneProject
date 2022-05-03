import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:toy_world/apis/deletes/delete_proposal.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_proposal.dart';
import 'package:toy_world/screens/new_contest_page.dart';
import 'package:toy_world/screens/profile_page.dart';

class ProposalDetailPage extends StatefulWidget {
  int role;
  String token;
  Proposal? proposal;

  ProposalDetailPage(
      {required this.role, required this.token, required this.proposal});

  @override
  State<ProposalDetailPage> createState() => _ProposalDetailPageState();
}

class _ProposalDetailPageState extends State<ProposalDetailPage> {
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          sideAppBar(context, widget.role, widget.token),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                        role: widget.role,
                                        token: widget.token,
                                        accountId: widget.proposal!.ownerId!,
                                      ))),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: CachedNetworkImageProvider(
                                widget.proposal?.ownerAvatar ?? _avatar),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                            widget.proposal?.ownerName ?? "Name",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      widget.proposal?.title ?? "Title",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Slogan: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.proposal?.slogan ?? "",
                            maxLines: 3,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Reason: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Flexible(
                              child: readMoreButton(
                                  widget.proposal?.reason ?? "",
                                  widget.proposal?.isReadMore ?? false,
                                  color: Colors.black87))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Rule: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Flexible(
                              child: readMoreButton(widget.proposal?.rule ?? "",
                                  widget.proposal?.isReadMore ?? false,
                                  color: Colors.black87))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Description: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Flexible(
                              child: readMoreButton(
                                  widget.proposal?.description ?? "",
                                  widget.proposal?.isReadMore ?? false,
                                  color: Colors.black87))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    widget.role == 1
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 140,
                                height: 60,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color(0xffC31432)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ))),
                                    child: const Text(
                                      "Delete",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                    onPressed: () async {
                                      DeleteProposal proposal =
                                          DeleteProposal();
                                      int status =
                                          await proposal.deleteProposal(
                                              token: widget.token,
                                              proposalId: widget.proposal?.id);
                                      if (status == 200) {
                                        loadingSuccess(
                                            status: "Delete Success");
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      } else {
                                        loadingFail(status: "Failed :(((((");
                                      }
                                    }),
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Container(
                                width: 140,
                                height: 60,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color(0xffDB36A4)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ))),
                                    child: const Text(
                                      "Create Contest",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => NewContestPage(
                                            role: widget.role,
                                            token: widget.token,
                                          )));
                                    }),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
