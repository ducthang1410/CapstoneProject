import 'package:flutter/material.dart';
import 'package:toy_world/models/model_proposal.dart';
import 'package:toy_world/screens/proposal_detail_page.dart';

class ProposalWidget extends StatefulWidget {
  int role;
  String token;
  Proposal proposal;

  ProposalWidget({required this.role, required this.token, required this.proposal});

  @override
  State<ProposalWidget> createState() => _ProposalWidgetState();
}

class _ProposalWidgetState extends State<ProposalWidget> {
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProposalDetailPage(
            role: widget.role,
            token: widget.token,
            proposal: widget.proposal,
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
                widget.proposal.ownerAvatar ?? _avatar,
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
                    widget.proposal.ownerName ?? "Name",
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
                          widget.proposal.title ?? "Title",
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
