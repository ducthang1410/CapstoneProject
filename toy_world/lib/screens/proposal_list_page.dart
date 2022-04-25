import 'package:flutter/material.dart';
import 'package:toy_world/apis/gets/get_all_proposal.dart';
import 'package:toy_world/models/model_proposal.dart';
import 'package:toy_world/screens/profile_page.dart';
import 'package:toy_world/screens/proposal_detail_page.dart';

class ProposalListPage extends StatefulWidget {
  int role;
  String token;

  ProposalListPage({required this.role, required this.token});

  @override
  State<ProposalListPage> createState() => _ProposalListPageState();
}

class _ProposalListPageState extends State<ProposalListPage> {
  Proposals? data;
  List<Proposal>? proposals;
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";

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
                        return _proposal(
                            title: proposals?[index].title ?? "Title",
                            ownerId: proposals?[index].ownerId,
                            ownerName: proposals?[index].ownerName ?? "Name",
                            ownerAvatar:
                                proposals?[index].ownerAvatar ?? _avatar,
                            proposal: proposals?[index]);
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

  Widget _proposal(
      {ownerId, ownerName, ownerAvatar, title, Proposal? proposal}) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProposalDetailPage(
                role: widget.role,
                token: widget.token,
                proposal: proposal,
              ))),
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.grey.shade300),
            bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            Material(
              child: Image.network(
                ownerAvatar,
                fit: BoxFit.cover,
                width: 60,
                height: 60,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: 60,
                    height: 60,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: const Color(0xffDB36A4),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, object, stackTrace) {
                  return const Icon(
                    Icons.account_circle,
                    size: 60,
                    color: Color(0xffaeaeae),
                  );
                },
              ),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              clipBehavior: Clip.hardEdge,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ownerName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18.0),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Title: ",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
