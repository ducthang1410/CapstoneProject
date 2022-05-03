import 'package:flutter/material.dart';
import 'package:toy_world/apis/gets/get_feedback_by_content.dart';
import 'package:toy_world/models/model_choice.dart';
import 'package:toy_world/models/model_feedback.dart';
import 'package:toy_world/screens/feedback_detail_page.dart';
import 'package:toy_world/screens/profile_page.dart';
import 'package:toy_world/utils/helpers.dart';

class FeedbackManagementPage extends StatefulWidget {
  int role;
  String token;

  FeedbackManagementPage({required this.role, required this.token});

  @override
  State<FeedbackManagementPage> createState() => _FeedbackManagementPageState();
}

class _FeedbackManagementPageState extends State<FeedbackManagementPage> {
  FeedbackModels? data;
  List<FeedbackModel>? feedbacks;

  int _limit = 10;
  final int _limitIncrement = 10;
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";

  final ScrollController listScrollController = ScrollController();

  List<Choice> items = <Choice>[
    Choice(id: 0, name: "Account"),
    Choice(id: 1, name: "Trading"),
    Choice(id: 2, name: "Post"),
    Choice(id: 3, name: "Submission"),
  ];
  Choice? selectedItem = Choice(id: 0, name: "Account");

  @override
  void initState() {
    // TODO: implement initState
    listScrollController.addListener(scrollListener);
    super.initState();
  }

  getData() async {
    FeedbackByContentList feedbackList = FeedbackByContentList();
    data = await feedbackList.getFeedbackByContent(
        token: widget.token, content: selectedItem!.id, size: _limit);
    if (data == null) return List.empty();
    feedbacks = data!.data!.cast<FeedbackModel>();
    setState(() {});
    return feedbacks;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5.0, right: 10.0),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: SizedBox(
              height: 60.0,
              width: 150.0,
              child: DropdownButtonFormField<Choice>(
                isExpanded: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(width: 3, color: Color(0xffDB36A4))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(width: 3, color: Color(0xffDB36A4))),
                ),
                onChanged: (Choice? newValue) {
                  setState(() {
                    selectedItem = newValue;
                  });
                },
                value: items[0],
                elevation: 16,
                items: items.map<DropdownMenuItem<Choice>>((Choice value) {
                  return DropdownMenuItem<Choice>(
                    value: value,
                    child: Center(child: Text(value.name)),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: FutureBuilder(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (feedbacks?.length != null && feedbacks!.isNotEmpty) {
                        return ListView.builder(
                            controller: listScrollController,
                            padding: EdgeInsets.zero,
                            itemCount: feedbacks?.length,
                            itemBuilder: (context, index) {
                              return _feedback(
                                feedback: feedbacks?[index],
                                senderId: feedbacks?[index].senderId,
                                senderAvatar:
                                    feedbacks?[index].senderAvatar ?? _avatar,
                                senderName:
                                    feedbacks?[index].senderName ?? "Name",
                                sendDate: feedbacks?[index].sendDate ??
                                    DateTime.now(),
                                content: feedbacks?[index].content ?? "",
                                feedbackAbout: feedbacks?[index].feedbackAbout,
                                contentId: feedbacks?[index].idForDetail,
                                replierId: feedbacks?[index].replierId,
                                replierContent: feedbacks?[index].replyContent,
                              );
                            });
                      } else {
                        return const Center(
                          child: Text("No feedback recently"),
                        );
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _feedback(
      {feedback,
      senderId,
      senderAvatar,
      senderName,
      sendDate,
      content,
      feedbackAbout,
      contentId,
      replierId,
      replierContent}) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(sendDate);
    String formattedDate = timeControl(difference);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FeedbackDetailPage(
                role: widget.role,
                token: widget.token,
                feedback: feedback,
              ))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.grey.shade300),
            bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            role: widget.role,
                            token: widget.token,
                            accountId: senderId,
                          ))),
                  child: Material(
                    child: Image.network(
                      senderAvatar,
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
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        senderName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18.0),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
                replierId != null && replierContent != null
                    ? const Icon(
                        Icons.check,
                        size: 24,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.close,
                        size: 24,
                        color: Colors.red,
                      )
              ],
            ),
            const SizedBox(
              height: 6.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reason: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                Expanded(
                  child: Text(
                    content,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
