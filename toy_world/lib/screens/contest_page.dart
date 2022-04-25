import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/apis/deletes/delete_contest_post.dart';
import 'package:toy_world/apis/gets/get_contest_detail.dart';
import 'package:toy_world/apis/gets/get_join_contest.dart';
import 'package:toy_world/apis/gets/get_post_contest.dart';
import 'package:toy_world/apis/gets/get_reward_contest.dart';
import 'package:toy_world/apis/posts/post_contest_post.dart';
import 'package:toy_world/apis/posts/post_evaluate_contest.dart';
import 'package:toy_world/apis/posts/post_feedback_post_contest.dart';
import 'package:toy_world/apis/posts/post_join_contest.dart';
import 'package:toy_world/apis/posts/post_rate_contest_post.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_check_join_contest.dart';
import 'package:toy_world/models/model_contest_detail.dart';
import 'package:toy_world/models/model_contest_post.dart';
import 'package:toy_world/models/model_image_post.dart';
import 'package:toy_world/models/model_prize.dart';
import 'package:toy_world/models/model_reward_contest.dart';
import 'package:toy_world/screens/manage_contest_page.dart';
import 'package:toy_world/screens/profile_page.dart';
import 'package:toy_world/screens/waiting_submission.dart';
import 'package:toy_world/utils/helpers.dart';
import 'package:intl/intl.dart';
import 'package:toy_world/widgets/subscriber_contest.dart';

class ContestPage extends StatefulWidget {
  int role;
  String token;
  int contestId;
  int contestStatus;
  String? contestImage;
  List<Prize>? prizes;

  ContestPage(
      {required this.role,
      required this.token,
      required this.contestId,
      this.contestImage,
      this.prizes,
      required this.contestStatus});

  @override
  State<ContestPage> createState() => _ContestPageState();
}

class _ContestPageState extends State<ContestPage>
    with SingleTickerProviderStateMixin {
  ContestPosts? data;
  List<ContestPost>? posts;
  List<Rate>? rates;
  ContestDetail? contestDetail;
  List<ImagePost>? images;
  List<RewardContest>? rewards;
  RewardPost? rewardPost;
  Prize? prizeReward;
  CheckJoinContest? hasJoined;

  int _currentUserId = 0;
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";
  int _limit = 10;
  final int _limitIncrement = 10;
  int _choice = 0;
  double rating = 0;
  String noteRating = "";
  bool isViewDetail = false;
  String feedbackContent = "";
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

  List<Asset> imagesPicker = <Asset>[];
  String _error = 'No Error Dectected';

  final ScrollController listScrollController = ScrollController();
  late TextEditingController controller;

  @override
  void initState() {
    // TODO: implement initState
    checkHasJoin();
    getRewardContest();
    getContestDetail();
    _loadCounter();
    listScrollController.addListener(scrollListener);
    controller = TextEditingController()
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = (prefs.getInt('accountId') ?? 0);
    });
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

  checkHasJoin() async {
    HasJoinedContest joined = HasJoinedContest();
    hasJoined = await joined.getHasJoinedContest(
        token: widget.token, contestId: widget.contestId);
    setState(() {});
    return hasJoined;
  }

  getContestDetail() async {
    ContestDetailApi contest = ContestDetailApi();
    contestDetail = await contest.getContestDetail(
        token: widget.token, contestId: widget.contestId);
    setState(() {});
    return contestDetail;
  }

  getRewardContest() async {
    RewardContestList rewardsContest = RewardContestList();
    rewards = await rewardsContest.getRewardContest(
        token: widget.token, contestId: widget.contestId);
    if (rewards == null) return List.empty();
    setState(() {});
    return rewards;
  }

  getData() async {
    ContestPostList contestPost = ContestPostList();
    data = await contestPost.getContestPost(
        token: widget.token, contestId: widget.contestId, size: _limit);
    if (data == null) return List.empty();
    posts = data!.data!.cast<ContestPost>();
    setState(() {});
    return posts;
  }

  checkJoinIn() async {
    JoinContest joinContest = JoinContest();
    int status = await joinContest.joinContest(
        token: widget.token, contestId: widget.contestId);
    if (status == 200) {
      setState(() {
        checkHasJoin();
      });
      loadingSuccess(status: "Join in success !!!");
    } else {
      loadingFail(
          status: "Your account is not available for this contest :((((");
    }
  }

  checkFeedbackPost(int postId) async {
    FeedbackContestPost feedback = FeedbackContestPost();
    int status = await feedback.feedbackContestPost(
        token: widget.token, contestPostId: postId, content: feedbackContent);
    if (status == 200) {
      setState(() {});
      loadingSuccess(
          status: "Send feedback success !!!\nPlease wait for manager reply.");
      Navigator.of(context).pop();
    } else {
      loadingFail(status: "Can not send feedback:((((");
    }
  }

  selectedPopupMenuButton(int postId, int value) async {
    switch (value) {
      case 1:
        showFeedbackContestPost(postId);
        break;
      case 2:
        DeleteContestPost post = DeleteContestPost();
        int status = await post.deleteContestPost(
            token: widget.token, contestPostId: postId);
        if (status == 200) {
          setState(() {});
        } else {
          loadingFail(status: "Delete Failed !!!");
        }
        break;
    }
  }

  void showFeedbackContestPost(int postId) => showDialog(
      context: context,
      builder: (contest) => Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                title: const Text(
                  "Feedback Post",
                  style: TextStyle(color: Color(0xffDB36A4), fontSize: 26),
                  textAlign: TextAlign.center,
                ),
                content: Stack(
                  overflow: Overflow.visible,
                  children: [
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            maxLines: 5,
                            onChanged: (value) {
                              setState(() {
                                feedbackContent = value.trim();
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: "Enter your feedback",
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0)),
                            ),
                          ),
                          Padding(
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
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            Colors.red,
                                          ),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ))),
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0),
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
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            Colors.lightGreen,
                                          ),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ))),
                                      child: const Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      ),
                                      onPressed: () =>
                                          checkFeedbackPost(postId),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: -40.0,
                      top: -95.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));

  void showRatingComment(Size size, ContestPost? contestPost) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            insetPadding:
                const EdgeInsets.symmetric(vertical: 100.0, horizontal: 20.0),
            contentPadding: EdgeInsets.zero,
            title: const Text(
              "Rate Comment",
              style: TextStyle(
                  color: Color(0xffDB36A4),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: Stack(
              overflow: Overflow.visible,
              children: [
                Positioned(
                  right: -20.0,
                  top: -85.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height,
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: contestPost?.rates?.length,
                        itemBuilder: (context, index) {
                          rates = contestPost?.rates ?? [];
                          if (rates!.isNotEmpty) {
                            return _rateComment(
                                ownerAvatar:
                                    rates?[index].ownerAvatar ?? _avatar,
                                ownerName: rates?[index].ownerName ?? "Name",
                                note: rates?[index].note ?? "",
                                numOfStar: rates?[index].numOfStar ?? 0);
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                  ),
                ),
              ],
            ),
          ));

  void showRating(Size size, int postId) => showDialog(
        context: context,
        builder: (context) => Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: const Text(
                "Rate Post",
                style: TextStyle(color: Color(0xffDB36A4), fontSize: 26),
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                width: size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildRating(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      maxLines: 5,
                      onChanged: (value) {
                        setState(() {
                          noteRating = value.trim();
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Enter your feedback",
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                      ),
                    ),
                    Padding(
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
                                      Colors.red,
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
                                  "OK",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                                onPressed: () {
                                  checkRateContestPost(postId);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  void showEvaluateContest(Size size) => showDialog(
        context: context,
        builder: (context) => Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: const Text(
                "Evaluate Contest",
                style: TextStyle(color: Color(0xffDB36A4), fontSize: 26),
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                width: size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildRating(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      maxLines: 5,
                      onChanged: (value) {
                        setState(() {
                          noteRating = value.trim();
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Enter your evaluation",
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                      ),
                    ),
                    Padding(
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
                                      Colors.red,
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
                                  "OK",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                                onPressed: () {
                                  checkEvaluateContest();
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  checkEvaluateContest() async {
    EvaluateContest evaluateContest = EvaluateContest();
    int status = await evaluateContest.evaluateContest(
        token: widget.token,
        contestId: widget.contestId,
        numOfStar: rating.toInt(),
        comment: noteRating);
    if (status == 200) {
      Navigator.of(context).pop();
      loadingSuccess(
          status:
              "We are appreciate your evaluation !!!\n Thanks for joining our contest");
    } else if (status == 400) {
      loadingFail(status: "Only people join contest can evaluate :((((");
    } else {
      loadingFail(status: "Evaluation failed :((((");
    }
  }

  checkRateContestPost(int postId) async {
    RateContestPost ratePost = RateContestPost();
    int status = await ratePost.rateContestPost(
        token: widget.token,
        contestId: widget.contestId,
        postId: postId,
        numOfStar: rating,
        note: noteRating);
    if (status == 200) {
      Navigator.of(context).pop();
      loadingSuccess(status: "Thanks for your rating !!!");
    } else if (status == 400) {
      loadingFail(status: "You had rated this post :((((");
    } else {
      loadingFail(status: "Rating failed :((((");
    }
  }

  checkNewContestPost(
      {token, contestId, content, List<String>? imagesLink}) async {
    NewContestPost post = NewContestPost();
    var status = await post.newContestPost(
        token: token,
        contestId: contestId,
        content: content,
        imagesUrl: imagesLink);
    return status;
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 100,
        enableCamera: true,
        selectedAssets: imagesPicker,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Select Photo",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      imagesPicker = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool hasJoinedContest = hasJoined?.isJoinedToContest ?? false;
    return Scaffold(
        backgroundColor: Colors.grey[300],
        resizeToAvoidBottomInset: false,
        body: NestedScrollView(
          controller: listScrollController,
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.contestImage ?? "",
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/img_not_available.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    groupAppBar(context, widget.role, widget.token),
                  ],
                ),
              ),
            ];
          },
          body: widget.role == 1
              ? DefaultTabController(
                  length: 4,
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
                              child: SizedBox(
                                width: 110,
                                child: Center(
                                  child: Text(
                                    "Contest",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: SizedBox(
                                width: 110,
                                child: Center(
                                  child: Text(
                                    "Subscriber",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: SizedBox(
                                width: 110,
                                child: Center(
                                  child: Text(
                                    "Submission",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: SizedBox(
                                width: 110,
                                child: Center(
                                  child: Text(
                                    "Management",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            buildContest(hasJoinedContest),
                            SubscriberContestWidget(
                                role: widget.role,
                                token: widget.token,
                                contestId: widget.contestId),
                            WaitingSubmissionPage(
                                role: widget.role,
                                token: widget.token,
                                contestId: widget.contestId),
                            ManageContestPage(
                              contestDetail: contestDetail,
                              contestId: widget.contestId,
                              token: widget.token,
                              prizes: widget.prizes,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : buildContest(hasJoinedContest),
        ));
  }

  Widget buildContest(bool hasJoinedContest) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildContestDetail(hasJoinedContest),
          widget.prizes!.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
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
          widget.contestStatus == 4
              ? buildRewardContest()
              : const SizedBox.shrink(),
          widget.contestStatus == 3 && hasJoinedContest == true
              ? Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Column(
                    children: [
                      _newPost(),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          Flexible(
            child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (posts?.length != null && posts!.isNotEmpty) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: posts?.length,
                          itemBuilder: (context, index) {
                            images = posts![index].images!.cast<ImagePost>();
                            return _post(
                                postId: posts?[index].id,
                                content: posts?[index].content ?? "",
                                ownerId: posts?[index].ownerId,
                                ownerAvatar:
                                    posts?[index].ownerAvatar ?? _avatar,
                                ownerName: posts?[index].ownerName ?? "",
                                averageStar: posts?[index].averageStar ?? 0,
                                contestPost: posts?[index],
                                isReadMore: posts?[index].isReadMore ?? false,
                                images: images,
                                isRated: posts?[index].isRated);
                          });
                    } else {
                      return const Center(
                          child: Text("There is no posts available:((((("));
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget buildContestDetail(bool hasJoinedContest) {
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
              contestDetail?.title ?? "Title",
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
                    contestDetail?.slogan ?? "",
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
                      child: readMoreButton(contestDetail?.rule ?? "",
                          contestDetail?.isReadMore ?? false,
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
                                contestDetail?.description ?? "",
                                contestDetail?.isReadMore ?? false,
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
                        DateFormat('dd MMMM yyyy kk:mm').format(
                            contestDetail?.startRegistration ?? DateTime.now()),
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
                        DateFormat('dd MMMM yyyy kk:mm').format(
                            contestDetail?.endRegistration ?? DateTime.now()),
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
                            .format(contestDetail?.startDate ?? DateTime.now()),
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
                            .format(contestDetail?.endDate ?? DateTime.now()),
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
                  height: 50,
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
                hasJoinedContest == false && widget.contestStatus == 1
                    ? Column(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 150,
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xffC31432)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ))),
                                child: const Text(
                                  "Join In",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                                onPressed: () {
                                  checkJoinIn();
                                }),
                          )
                        ],
                      )
                    : widget.contestStatus == 4
                        ? Column(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: 150,
                                height: 50,
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
                                      "Evaluate",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                    onPressed: () {
                                      showEvaluateContest(size);
                                    }),
                              )
                            ],
                          )
                        : const SizedBox.shrink(),
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

  Widget buildRewardContest() {
    int numReward = rewards?.length ?? 0;
    return numReward > 0
        ? Container(
            color: const Color(0xff340761),
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Column(
              children: [
                const Text(
                  "Congratulation The Winners",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffefeff1),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildReward(
                        rewards?[1].rewardPost?.sumOfStart ?? 0,
                        rewards?[1].rewardPost?.ownerAvatar ?? _avatar,
                        35.0,
                        Colors.grey.shade200,
                        24.0,
                        rewards?[1].rewardPost?.ownerName ?? "Name",
                        prizeIcon[1],
                        rewards![1].rewardPost!),
                    Expanded(
                      child: buildReward(
                          rewards?[0].rewardPost?.sumOfStart ?? 0,
                          rewards?[0].rewardPost?.ownerAvatar ?? _avatar,
                          50.0,
                          Colors.amber,
                          39.0,
                          rewards?[0].rewardPost?.ownerName ?? "Name",
                          prizeIcon[0],
                          rewards![0].rewardPost!),
                    ),
                    buildReward(
                        rewards?[2].rewardPost?.sumOfStart ?? 0,
                        rewards?[2].rewardPost?.ownerAvatar ?? _avatar,
                        35.0,
                        Colors.brown,
                        24.0,
                        rewards?[2].rewardPost?.ownerName ?? "Name",
                        prizeIcon[2],
                        rewards![2].rewardPost!),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  "CONGRATULATIONS TO ALL",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  "The Toy World Contest Team, the Judges and the Sponsors of the contest thank you for your participation and hope to see you next season!",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                    "The 3 winners will be contacted by email to send the prizes!",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                    "Your project does not appear in the gallery? It is possible that it was not selected for example because of a breach of the rules. Do not hesitate to contact us for more information.",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget buildReward(numOfStar, ownerAvatar, sizeAvatar, color, position,
      ownerName, prizeIcon, RewardPost rewardPost) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$numOfStar ",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber),
              ),
              const Icon(
                Icons.star,
                color: Colors.amber,
              )
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Stack(
            overflow: Overflow.visible,
            children: [
              CircleAvatar(
                radius: sizeAvatar + 5,
                backgroundColor: color,
                child: CircleAvatar(
                  radius: sizeAvatar,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: CachedNetworkImageProvider(ownerAvatar),
                ),
              ),
              Positioned(
                  bottom: -5,
                  right: position,
                  child: Image.asset(
                    prizeIcon,
                    width: 30,
                  ))
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            ownerName,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xffefeff1),
            ),
          )
        ],
      ),
    );
  }

  Widget _newPost() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: CachedNetworkImageProvider(_avatar),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Post your product ...',
                    ),
                  ),
                )
              ],
            ),
            const Divider(height: 10.0, thickness: 0.5),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: loadAssets,
                    icon: const Icon(
                      Icons.photo_library,
                      color: Color(0xffDB36A4),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xffDB36A4)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                      onPressed: () async {
                        try {
                          List<String> imageUrls;
                          imageUrls =
                              await uploadImages(imagesPicker, "Runner");
                          if (await checkNewContestPost(
                                  token: widget.token,
                                  contestId: widget.contestId,
                                  content: controller.text,
                                  imagesLink: imageUrls) ==
                              200) {
                            setState(() {
                              imagesPicker.clear();
                              controller.clear();
                            });
                            loadingSuccess(status: "Post success!!!");
                          } else {
                            loadingFail(
                                status:
                                    "Create Post Failed - ${await checkNewContestPost(token: widget.token, contestId: widget.contestId, content: controller.text)}");
                          }
                        } catch (e) {
                          loadingFail(status: "Create Post Failed !!! \n $e");
                        }
                      },
                      child: const Text(
                        'Post',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ))
                ],
              ),
            ),
            imagesPicker.isNotEmpty
                ? buildGridViewImagePicker()
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _post(
      {postId,
      ownerId,
      ownerAvatar,
      ownerName,
      averageStar,
      content,
      isRated,
      List<ImagePost>? images,
      ContestPost? contestPost,
      isReadMore}) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _postHeader(
                    postId: postId,
                    ownerId: ownerId,
                    ownerAvatar: ownerAvatar,
                    ownerName: ownerName,
                    averageStar: averageStar),
                const SizedBox(
                  height: 4.0,
                ),
                readMoreButton(content, isReadMore),
                images!.isNotEmpty
                    ? const SizedBox.shrink()
                    : const SizedBox(
                        height: 6.0,
                      ),
              ],
            ),
          ),
          images.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GridView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    primary: false,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: imageShow(images, size),
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    children: buildImages(),
                  ),
                )
              : const SizedBox.shrink(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: _postStats(
                postId: postId, isRated: isRated, contestPost: contestPost),
          ),
        ],
      ),
    );
  }

  Widget buildGridViewImagePicker() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 6,
      children: List.generate(imagesPicker.length, (index) {
        Asset asset = imagesPicker[index];
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              ),
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  color: const Color.fromRGBO(255, 255, 244, 0.2),
                  child: IconButton(
                    onPressed: () {
                      imagesPicker.removeAt(index);
                      setState(() {});
                    },
                    icon: const Icon(Icons.delete),
                    color: Colors.black87,
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _postHeader(
      {postId, ownerId, ownerAvatar, ownerName, double? averageStar}) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfilePage(
                    role: widget.role,
                    token: widget.token,
                    accountId: ownerId,
                  ))),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            backgroundImage: CachedNetworkImageProvider(ownerAvatar),
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
                ownerName,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Row(
                children: [
                  Text(
                    double.parse((averageStar)!.toStringAsFixed(2)).toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.amber),
                  ),
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  )
                ],
              ),
            ],
          ),
        ),
        PopupMenuButton(
            icon: const Icon(Icons.more_horiz),
            onSelected: (int value) {
              setState(() {
                _choice = value;
                selectedPopupMenuButton(postId, _choice);
              });
            },
            itemBuilder: (context) =>
                (widget.role == 1 || ownerId == _currentUserId) &&
                        widget.contestStatus != 4
                    ? const [
                        PopupMenuItem(
                          child: Text("Feedback"),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: Text("Delete post"),
                          value: 2,
                        )
                      ]
                    : const [
                        PopupMenuItem(
                          child: Text("Feedback"),
                          value: 1,
                        ),
                      ]),
      ],
    );
  }

  Widget _postStats({isRated, postId, ContestPost? contestPost}) {
    var size = MediaQuery.of(context).size;
    return Row(
      children: [
        _postButton(
            Icon(
              FontAwesomeIcons.solidStar,
              color: isRated ? Colors.amber : Colors.grey[600],
              size: 20,
            ),
            Text(
              isRated ? "Rated" : "Rate",
              style: TextStyle(
                  color: isRated ? Colors.amber : Colors.grey[600],
                  fontWeight: isRated ? FontWeight.bold : null,
                  fontSize: 16),
            ),
            onTap: () =>
                widget.contestStatus == 3 ? showRating(size, postId) : () {}),
        _postButton(
            Icon(
              FontAwesomeIcons.comment,
              color: Colors.grey[600],
              size: 20,
            ),
            const Text(
              "Rate Comment",
              style: TextStyle(fontSize: 16),
            ),
            onTap: () => showRatingComment(size, contestPost)),
      ],
    );
  }

  Widget _postButton(Icon icon, Text text, {onTap}) {
    return Expanded(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 25.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(
                  width: 10.0,
                ),
                text
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildImages() {
    int numImages = images!.length;
    int maxImages = 4;
    return List<Widget>.generate(min(numImages, maxImages), (index) {
      String? imageUrl = images![index].url;

      // If its the last image
      if (index == maxImages - 1) {
        // Check how many more images are left
        int remaining = numImages - maxImages;

        // If no more are remaining return a simple image widget
        if (remaining == 0) {
          return GestureDetector(
            child: CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Image.network(
                "https://www.trendsetter.com/pub/media/catalog/product/placeholder/default/no_image_placeholder.jpg",
                fit: BoxFit.cover,
              ),
            ),
            onTap: () {
              onImageClicked(context, imageUrl, widget.role, widget.token);
            },
          );
        } else {
          // Create the facebook like effect for the last image with number of remaining  images
          return GestureDetector(
            onTap: () => onExpandClicked(
                context, images ?? [], widget.role, widget.token),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/img_not_available.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black54,
                    child: Text(
                      '+' + remaining.toString(),
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        return GestureDetector(
          child: CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/img_not_available.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {
            onImageClicked(context, imageUrl, widget.role, widget.token);
          },
        );
      }
    });
  }

  Widget buildRating() => RatingBar.builder(
      minRating: 1,
      maxRating: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
      updateOnDrag: true,
      onRatingUpdate: (rating) {
        setState(() {
          this.rating = rating;
        });
      });

  Widget _rateComment({ownerAvatar, ownerName, note, numOfStar}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0, 10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[200],
            backgroundImage: CachedNetworkImageProvider(ownerAvatar),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
              child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.grey.shade200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ownerName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  note,
                  style: const TextStyle(color: Colors.black),
                )
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  "$numOfStar ",
                  style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
