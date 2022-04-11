import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:toy_world/apis/deletes/delete_contest.dart';
import 'package:toy_world/components/component.dart';
import 'package:intl/intl.dart';
import 'package:toy_world/models/model_contest_detail.dart';
import 'package:toy_world/models/model_image_post.dart';
import 'package:toy_world/models/model_prize.dart';
import 'package:toy_world/utils/helpers.dart';

class ManageContestPage extends StatefulWidget {
  ContestDetail? contestDetail;
  String token;
  int contestId;
  List<Prize>? prizes;

  ManageContestPage(
      {required this.contestDetail,
      required this.token,
      this.prizes,
      required this.contestId});

  @override
  State<ManageContestPage> createState() => _ManageContestPageState();
}

class _ManageContestPageState extends State<ManageContestPage> {
  bool isViewDetail = false;
  List<ImagePost>? images;
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

  showConfirmDialog(Size size) => showDialog(context: context, builder: (context) => Center(
    child: AlertDialog(title: const Text(
      "Confirm To Delete Contest",
      style: TextStyle(color: Color(0xffDB36A4), fontSize: 26),
      textAlign: TextAlign.center,
    ),
      content: SizedBox(
        height: size.height * 0.2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Are you sure to delete this contest? "),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        width: 130,
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.redAccent,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.0),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Flexible(
                      child: Container(
                        width: 130,
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.lightGreen,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                          child: const Text(
                            "Confirm",
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.0),
                          ),
                          onPressed: () async {
                            DeleteContest contest = DeleteContest();
                            int status = await contest.deleteContest(
                                token: widget.token, contestId: widget.contestId);
                            if (status == 200) {
                              setState(() {});
                              loadingSuccess(status: "Delete success");
                              Navigator.of(context).pop();
                            } else {
                              loadingFail(status: "Delete Failed !!!");
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  ));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          buildContestDetail(
            title: widget.contestDetail?.title ?? "Title",
            slogan: widget.contestDetail?.slogan ?? "",
            description: widget.contestDetail?.description ?? "",
            rule: widget.contestDetail?.rule ?? "",
            startRegistration:
                widget.contestDetail?.startRegistration ?? DateTime.now(),
            endRegistration:
                widget.contestDetail?.endRegistration ?? DateTime.now(),
            startDate: widget.contestDetail?.startDate ?? DateTime.now(),
            endDate: widget.contestDetail?.endDate ?? DateTime.now(),
            isReadMore: widget.contestDetail?.isReadMore ?? false,
          ),
          widget.prizes!.isNotEmpty
          ? Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            color: Colors.white,
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Prize",
                  style: TextStyle(
                      color: Color(0xffDB36A4),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Flexible(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: widget.prizes?.length,
                      itemBuilder: (context, index) {
                        images = widget.prizes?[index].images ?? [];
                        return prize(
                            prizeImage: images!.isNotEmpty
                                ? images?.first.url
                                : "",
                            prizeIcon: prizeIcon[index],
                            name: widget.prizes?[index].name ??
                                "Name Prize",
                            value:
                            widget.prizes?[index].value ?? "Value");
                      }),
                ),
              ],
            ),
          )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget buildContestDetail(
      {title,
      slogan,
      description,
      rule,
      startRegistration,
      endRegistration,
      startDate,
      endDate,
      isReadMore}) {
    var size = MediaQuery.of(context).size;
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
        width: size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Color(0xff050942),
            Color(0xff302B63),
          ],
        )),
        child: Column(
          children: [
            Image.asset(
              "assets/images/contest_icon.png",
              width: size.width * 0.6,
            ),
            Text(
              title ?? "Title",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Slogan: ",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    slogan ?? "",
                    maxLines: 3,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Rule: ",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Flexible(
                      child: readMoreButton(rule ?? "", isReadMore ?? false,
                          color: Colors.white))
                ],
              ),
            ),
            Visibility(
              visible: isViewDetail,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Description: ",
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                            child: readMoreButton(
                                description ?? "", isReadMore ?? false,
                                color: Colors.white))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Start Registration: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        DateFormat('dd MMMM yyyy kk:mm')
                            .format(startRegistration ?? DateTime.now()),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'End Registration: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        DateFormat('dd MMMM yyyy kk:mm')
                            .format(endRegistration ?? DateTime.now()),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Start Date: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        DateFormat('dd MMMM yyyy kk:mm')
                            .format(startDate ?? DateTime.now()),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'End Date: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        DateFormat('dd MMMM yyyy kk:mm')
                            .format(endDate ?? DateTime.now()),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 60,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xffC31432)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                      child: const Text(
                        "Delete Contest",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      onPressed: () async {
                        await showConfirmDialog(size);
                        Navigator.of(context).pop();
                      }),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 150,
                  height: 60,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xffC31432)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                      child: Text(
                        isViewDetail == false ? "View Detail" : "Hide Detail",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16.0),
                      ),
                      onPressed: () {
                        setState(() {
                          isViewDetail = !isViewDetail;
                        });
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget prize({prizeImage, prizeIcon, name, value}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          prizeImage != ""
              ? CachedNetworkImage(
            imageUrl: prizeImage,
            width: 50,
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/img_not_available.jpeg',
              fit: BoxFit.cover,
            ),
          )
              : Image.asset(
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
