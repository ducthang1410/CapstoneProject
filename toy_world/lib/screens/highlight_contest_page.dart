import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:toy_world/apis/gets/get_highlight_contest.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_contest.dart';
import 'package:toy_world/models/model_contest_group.dart';
import 'package:toy_world/models/model_prize.dart';
import 'package:intl/intl.dart';
import 'package:toy_world/screens/contest_page.dart';
import 'package:toy_world/utils/helpers.dart';

class HighlightContestPage extends StatefulWidget {
  int role;
  String token;

  HighlightContestPage({required this.role, required this.token});

  @override
  State<HighlightContestPage> createState() => _HighlightContestPageState();
}

class _HighlightContestPageState extends State<HighlightContestPage> {
  int _limit = 10;
  final int _limitIncrement = 10;

  ContestGroup? data;
  List<Contest>? contests;

  List<String> prizeIcon = [
    "assets/icons/1_prize.png",
    "assets/icons/2_prize.png",
    "assets/icons/3_prize.png",
    "assets/icons/others.png",
    "assets/icons/others.png",
    "assets/icons/others.png",
    "assets/icons/others.png",
    "assets/icons/others.png",
    "assets/icons/others.png",
  ];

  final ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    getData();
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
    HighlightContestList highlightContestList = HighlightContestList();
    data = await highlightContestList.getHighlightContestList(
        token: widget.token, size: _limit);
    if (data == null) return List.empty();
    contests = data!.data!.cast<Contest>();
    setState(() {});
    return contests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (contests?.length != null && contests!.isNotEmpty) {
                return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: contests?.length,
                    itemBuilder: (context, index) {
                      return _contest(
                          contestId: contests?[index].id,
                          title: contests?[index].title ?? "",
                          coverImage: contests?[index].coverImage ?? "",
                          slogan: contests?[index].slogan ??
                              "Enjoy and play with your passion !!!",
                          description:
                          contests?[index].description ?? "",
                          startRegistration:
                          contests?[index].startRegistration ??
                              DateTime.now().toString(),
                          endRegistration:
                          contests?[index].endRegistration ??
                              DateTime.now().toString(),
                          startDate: contests?[index].startDate ??
                              DateTime.now().toString(),
                          endDate: contests?[index].endDate ??
                              DateTime.now().toString(),
                          isReadMore:
                          contests?[index].isReadMore ?? false,
                          status: contests?[index].status ?? 0);
                    });
              } else {
                return const Center(
                    child: Text("There is no contest available:(((("));
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget _contest(
      {contestId,
      title,
      description,
      startRegistration,
      endRegistration,
      startDate,
      endDate,
      coverImage,
      slogan,
      isReadMore,
      status}) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(5.0),
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border:
            Border.all(width: 1, style: BorderStyle.solid, color: Colors.grey),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 1,
            offset: Offset(0, 0), // Shadow position
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: coverImage,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Image.asset(
                'assets/images/img_not_available.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              title,
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              alignment: Alignment.centerLeft,
              child: Text(
                "Slogan: " + slogan,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                alignment: Alignment.centerLeft,
                child: readMoreButton(description, isReadMore)),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Start Registration: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87),
                              ),
                              Text(
                                DateFormat('dd MMM kk:mm')
                                    .format(startRegistration),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'End Registration: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87),
                              ),
                              Text(
                                DateFormat('dd MMM kk:mm')
                                    .format(endRegistration),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Start Date: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87),
                              ),
                              Text(
                                DateFormat('dd MMM kk:mm').format(startDate),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'End Date: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87),
                              ),
                              Text(
                                DateFormat('dd MMM kk:mm').format(endDate),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: SizedBox(
                      width: 130,
                      height: 40,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xffDB36A4),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                        child: const Text(
                          "View Detail",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ContestPage(
                                role: widget.role,
                                token: widget.token,
                                contestId: contestId,
                              )));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // prizes!.isNotEmpty
            //     ? Container(
            //         padding: const EdgeInsets.symmetric(vertical: 10.0),
            //         width: double.infinity,
            //         child: Column(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             const Text(
            //               "Prize",
            //               style: TextStyle(
            //                   color: Color(0xffDB36A4),
            //                   fontSize: 30,
            //                   fontWeight: FontWeight.bold),
            //             ),
            //             const SizedBox(
            //               height: 10.0,
            //             ),
            //             Flexible(
            //               child: ListView.builder(
            //                   primary: false,
            //                   padding: EdgeInsets.zero,
            //                   itemCount: prizes.length,
            //                   shrinkWrap: true,
            //                   itemBuilder: (context, index) {
            //                     return buildPrize(
            //                         prizeIcon: prizeIcon[index],
            //                         name: prizes[index].name,
            //                         value: prizes[index].value);
            //                   }),
            //             )
            //           ],
            //         ),
            //       )
            //     : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget buildPrize({prizeIcon, name, value}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            prizeIcon,
            width: 50,
          ),
          const SizedBox(
            width: 20.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name ?? "Prize",
                style: TextStyle(
                    fontSize: 20.0,
                    color: showPrize(name),
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Text("Reward: ",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  Text(
                    value + " VND" ?? "",
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
