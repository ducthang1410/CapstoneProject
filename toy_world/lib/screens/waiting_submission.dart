import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:toy_world/apis/gets/get_waiting_submission.dart';
import 'package:toy_world/apis/puts/put_approve_deny_waiting_submission.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_image_post.dart';
import 'package:toy_world/models/model_waiting_submission.dart';
import 'package:toy_world/screens/profile_page.dart';
import 'package:toy_world/utils/helpers.dart';

class WaitingSubmissionPage extends StatefulWidget {
  int role;
  String token;
  int contestId;

  WaitingSubmissionPage(
      {required this.role, required this.token, required this.contestId});

  @override
  State<WaitingSubmissionPage> createState() => _WaitingSubmissionPageState();
}

class _WaitingSubmissionPageState extends State<WaitingSubmissionPage> {
  WaitingSubmissions? data;
  List<WaitingSubmission>? submissions;
  List<ImagePost>? images;
  int _limit = 10;
  final int _limitIncrement = 10;
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";

  final ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    listScrollController.addListener(scrollListener);

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
    WaitingSubmissionList waitingSubmission = WaitingSubmissionList();
    data = await waitingSubmission.getWaitingSubmission(
        token: widget.token, contestId: widget.contestId, size: _limit);
    if (data == null) return List.empty();
    submissions = data!.data!.cast<WaitingSubmission>();
    setState(() {});
    return submissions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (submissions?.length != null && submissions!.isNotEmpty) {
                return ListView.builder(
                    controller: listScrollController,
                    padding: EdgeInsets.zero,
                    itemCount: submissions?.length,
                    itemBuilder: (context, index) {
                      images = submissions![index].images!.cast<ImagePost>();
                      return _post(
                        postId: submissions?[index].id,
                        ownerAvatar: submissions?[index].ownerAvatar ?? _avatar,
                        ownerName: submissions?[index].ownerName ?? "Name",
                        content: submissions?[index].content ?? "Content",
                        isReadMore: submissions?[index].isReadMore ?? false,
                        images: images,
                        dateCreate:
                            submissions?[index].dateCreate ?? DateTime.now(),
                      );
                    });
              } else {
                return const Center(
                    child: Text("There is no posts"));
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget _post(
      {postId,
      ownerId,
      ownerAvatar,
      ownerName,
      dateCreate,
      content,
      List<ImagePost>? images,
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
                  dateCreate: dateCreate
                ),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: _postButton(
                      const Icon(
                        Icons.cancel,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                      const Text(
                        "Deny",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      onTap: () async {
                        loadingLoad(status: "Loading...");
                        ApproveDenyWaitingSubmission submission =
                            ApproveDenyWaitingSubmission();
                        int status =
                            await submission.approveDenyWaitingSubmission(
                                token: widget.token,
                                submissionId: postId,
                                choice: 0);
                        if (status == 200) {
                          setState(() {});
                          loadingSuccess(status: "Deny Success");
                        } else {
                          loadingFail(status: "Deny Failed !!!");
                        }
                      },
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: _postButton(
                      const Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 20,
                      ),
                      const Text(
                        "Approve",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      onTap: () async {
                        loadingLoad(status: "Loading...");
                        ApproveDenyWaitingSubmission submission =
                            ApproveDenyWaitingSubmission();
                        int status =
                            await submission.approveDenyWaitingSubmission(
                                token: widget.token,
                                submissionId: postId,
                                choice: 1);
                        if (status == 200) {
                          setState(() {});
                          loadingSuccess(status: "Approve Success");
                        } else {
                          loadingFail(status: "Approve Failed !!!");
                        }
                      },
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _postHeader({postId, ownerId, ownerAvatar, ownerName, dateCreate}) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateCreate);
    String formattedDate = timeControl(difference);
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
                    formattedDate + " *",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                  )
                ],
              )
            ],
          ),
        ),
      ],
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

  Widget _postButton(Icon icon, Text text, {onTap}) {
    return Material(
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
                width: 8.0,
              ),
              text
            ],
          ),
        ),
      ),
    );
  }
}
