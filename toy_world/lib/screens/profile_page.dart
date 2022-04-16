import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/apis/gets/get_account_info.dart';
import 'package:toy_world/apis/gets/get_account_profile.dart';
import 'package:toy_world/apis/posts/post_follow_unfollow.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_account_info.dart';
import 'package:toy_world/models/model_account_profile.dart';
import 'package:toy_world/screens/follower_account_page.dart';
import 'package:toy_world/screens/following_account_page.dart';
import 'package:toy_world/screens/post_of_account_page.dart';

class ProfilePage extends StatefulWidget {
  int role;
  String token;
  int accountId;

  ProfilePage(
      {required this.role, required this.token, required this.accountId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AccountDetail? _accountDetail;
  AccountInfo? _accountInfo;
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";
  int _currentUserId = 0;
  bool? isFollow = false;

  @override
  void initState() {
    // TODO: implement initState
    _loadCounter();
    getAccountDetail();
    getAccountInfo();
    super.initState();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = (prefs.getInt('accountId') ?? 0);
    });
  }

  getAccountDetail() async {
    AccountDetailData accountDetailData = AccountDetailData();
    _accountDetail = await accountDetailData.getAccountDetail(
        token: widget.token, accountId: widget.accountId);
    if (!mounted) return;
    setState(() {});
    return _accountDetail;
  }

  getAccountInfo() async {
    AccountInfoData accountInfoData = AccountInfoData();
    _accountInfo = await accountInfoData.getAccountInfo(
        token: widget.token, accountId: widget.accountId);
    if (!mounted) return;
    setState(() {});
    return _accountInfo;
  }

  checkFollowUnfollow() async {
    FollowUnfollowAccount account = FollowUnfollowAccount();
    int status = await account.followUnfollowAccount(
        token: widget.token, accountId: widget.accountId);
    if (status == 200) {
      setState(() {
        isFollow = !isFollow!;
      });
    } else {
      loadingFail(status: "Follow/Unfollow failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          sideAppBar(context, widget.role, widget.token),
          Expanded(
            child: FutureBuilder(
              future: getAccountDetail(),
              builder: (context, snapshot) {
                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _avatarContent(context),
                    _informationContent(context),
                  ],
                );
              }
            ),
          )
        ],
      ),
    );
  }

  Widget _avatarContent(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double coverHeight = size.height * 0.2;
    final top = coverHeight - size.height * 0.09;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: size.width,
          height: coverHeight,
          margin: EdgeInsets.only(bottom: size.height * 0.09),
          child: Image.asset(
            "assets/images/toyType4.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Positioned(top: top, child: _profileImage(size))
      ],
    );
  }

  Widget _profileImage(Size size) {
    return CircleAvatar(
      radius: size.height * 0.09,
      backgroundColor: Colors.grey.shade300,
      backgroundImage:
          CachedNetworkImageProvider(_accountDetail?.avatar ?? _avatar),
    );
  }

  Widget _informationContent(BuildContext context) {
    isFollow = _accountDetail?.isFollowed ?? false;
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          _accountDetail?.name ?? "Name",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        widget.accountId != _currentUserId
            ? Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 130,
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xffDB36A4)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                        child: Text(
                          isFollow == false
                              ? "Follow"
                              : "Unfollow",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16.0),
                        ),
                        onPressed: () {
                          checkFollowUnfollow();
                        }),
                  ),
                ],
              )
            : const SizedBox.shrink(),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          thickness: 0.5,
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumber(size,
                value: "${_accountDetail?.noOfPost ?? "0"}",
                text: "Post",
                function: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PostAccountPage(
                          role: widget.role,
                          token: widget.token,
                          accountID: widget.accountId,
                        )))),
            _buildNumber(size,
                value: "${_accountDetail?.noOfFollowing ?? "0"}",
                text: "Following",
                function: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FollowingPage(
                          role: widget.role,
                          token: widget.token,
                          currentUserId: widget.accountId,
                        )))),
            _buildNumber(size,
                value: "${_accountDetail?.noOfFollower ?? "0"}",
                text: "Follower",
                function: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FollowerPage(
                          role: widget.role,
                          token: widget.token,
                          currentUserId: widget.accountId,
                        )))),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          thickness: 0.5,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: const Text("About me",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(
          height: 10,
        ),
        containerProfile(size,
            title: "Gender", content: _accountInfo?.gender ?? ""),
        containerProfile(size,
            title: "Email", content: _accountInfo?.email ?? ""),
        containerProfile(size,
            title: "Phone", content: _accountInfo?.phone ?? ""),
        const Divider(
          thickness: 0.5,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: const Text("Biography",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
        Container(
            margin: const EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            child: Text(
              _accountDetail?.biography ?? "",
              style: const TextStyle(color: Colors.black54, fontSize: 16),
            ))
      ],
    );
  }

  Widget _buildNumber(size, {String? value, String? text, function}) {
    return SizedBox(
      width: size.width * 0.3,
      child: MaterialButton(
        onPressed: function,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "$value",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black87),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              "$text",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget containerProfile(size, {String? title, String? content}) {
    return SizedBox(
      height: size.height * 0.07,
      width: size.width,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 20),
                    width: size.width * 0.2,
                    child: Text(
                      "$title",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    child: Text(
                  "$content",
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
