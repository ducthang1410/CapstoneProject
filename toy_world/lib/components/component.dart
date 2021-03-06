import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toy_world/screens/message_list_page.dart';
import 'package:toy_world/screens/profile_page.dart';
import 'package:toy_world/utils/helpers.dart';
import 'package:readmore/readmore.dart';

void loadingLoad({required status}) {
  EasyLoading.show(
    status: "$status",
    maskType: EasyLoadingMaskType.black,
  );
}

void loadingFail({required status}) {
  EasyLoading.showError("$status",
      maskType: EasyLoadingMaskType.black,
      duration: const Duration(seconds: 2));
}

void loadingSuccess({required status}) {
  EasyLoading.showSuccess("$status",
      maskType: EasyLoadingMaskType.black,
      duration: const Duration(seconds: 2));
}

Widget defaultAppBar(BuildContext context, int role, String token) {
  var size = MediaQuery.of(context).size;
  return Center(
    child: Container(
      width: size.width,
      height: 80,
      color: const Color(0xffDB36A4),
      padding: const EdgeInsets.only(left: 5, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/icons/Logo_Word_Black_Pink.png",
              height: 60,
            ),
          ),
          SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        shape: BoxShape.circle),
                    child: IconButton(
                      iconSize: 30,
                      alignment: Alignment.center,
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        shape: BoxShape.circle),
                    child: IconButton(
                      alignment: Alignment.center,
                      iconSize: 30,
                      icon: const Icon(FontAwesomeIcons.commentDots,
                          color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MessageListPage(role: role, token: token,),
                        ));
                      },
                    ),
                  ),
                ],
              ))
        ],
      ),
    ),
  );
}

Widget groupAppBar(BuildContext context, int role, String token) {
  var size = MediaQuery.of(context).size;
  return Center(
    child: Opacity(
      opacity: 0.8,
      child: Container(
        width: size.width,
        height: 80,
        padding: const EdgeInsets.only(left: 5, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                iconSize: 30,
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop()),
            SizedBox(
                width: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      iconSize: 30,
                      alignment: Alignment.center,
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      alignment: Alignment.center,
                      iconSize: 30,
                      icon: const Icon(FontAwesomeIcons.commentDots,
                          color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MessageListPage(role: role, token: token),
                        ));
                      },
                    ),
                  ],
                ))
          ],
        ),
      ),
    ),
  );
}

Widget sideAppBar(BuildContext context, int role, String token) {
  var size = MediaQuery.of(context).size;
  return Center(
    child: Container(
      width: size.width,
      height: 80,
      color: const Color(0xffDB36A4),
      padding: const EdgeInsets.only(left: 5, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.of(context).pop()),
          SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        shape: BoxShape.circle),
                    child: IconButton(
                      iconSize: 30,
                      alignment: Alignment.center,
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        shape: BoxShape.circle),
                    child: IconButton(
                      alignment: Alignment.center,
                      iconSize: 30,
                      icon: const Icon(FontAwesomeIcons.commentDots,
                          color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MessageListPage(role: role, token: token,),
                        ));
                      },
                    ),
                  ),
                ],
              ))
        ],
      ),
    ),
  );
}

Widget drawerMenu(BuildContext context, int role, String token, String name,
    String urlImage, {currentUserId, accountId}) {
  var size = MediaQuery.of(context).size;
  return SizedBox(
      width: 300,
      height: size.height,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
        child: Drawer(
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xffDB36A4),
                Color(0xffF7FF00),
              ],
            )),
            child: ListView(
              children: [
                buildHeader(
                    urlImage: urlImage,
                    name: name,
                    onClicked: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          accountId: accountId,
                          role: role,
                          token: token,
                        ),
                      ));
                    }),
                Column(
                  children: [
                    const Divider(
                      color: Color(0xffDB36A4),
                      thickness: 1,
                    ),
                    buildMenuItem(
                      text: 'Following',
                      urlImage: "assets/icons/followers.png",
                      onClicked: () {
                        Navigator.of(context).pop();
                        selectedDrawerItem(context, 0, role, token, currentUserId: currentUserId);
                      },
                    ),
                    const Divider(
                      color: Color(0xffDB36A4),
                      thickness: 1,
                    ),
                    buildMenuItem(
                      text: 'Proposal',
                      urlImage: "assets/icons/proposal.png",
                      onClicked: () {
                        Navigator.of(context).pop();
                        selectedDrawerItem(context, 1, role, token, currentUserId: currentUserId);
                      },
                    ),
                    role == 1
                        ? Column(
                            children: [
                              const Divider(
                                color: Color(0xffDB36A4),
                                thickness: 1,
                              ),
                              buildMenuItem(
                                text: 'Management',
                                urlImage: "assets/icons/management.png",
                                onClicked: () {
                                  Navigator.of(context).pop();
                                  selectedDrawerItem(context, 2, role, token);
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    const Divider(
                      color: Color(0xffDB36A4),
                      thickness: 1,
                    ),
                    buildMenuItem(
                      text: 'Toys',
                      urlImage: "assets/icons/toy.png",
                      onClicked: () {
                        Navigator.of(context).pop();
                        selectedDrawerItem(context, 3, role, token);
                      },
                    ),
                    const Divider(
                      color: Color(0xffDB36A4),
                      thickness: 1,
                    ),
                    buildMenuItem(
                      text: 'Sign out',
                      urlImage: "assets/icons/logout.png",
                      onClicked: () {
                        Navigator.of(context).pop();
                        selectedDrawerItem(context, 4, role, token);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ));
}

Widget buildHeader({
  required String urlImage,
  required String name,
  required VoidCallback onClicked,
}) =>
    InkWell(
      onTap: onClicked,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(urlImage),
                backgroundColor: Colors.grey.shade300),
            const SizedBox(height: 20),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );

Widget buildMenuItem({
  required String text,
  required String urlImage,
  VoidCallback? onClicked,
}) {
  return Container(
    padding: const EdgeInsets.only(left: 30, right: 10),
    child: ListTile(
      leading: SizedBox(
        height: 30,
        width: 30,
        child: Image.asset(urlImage, fit: BoxFit.cover),
      ),
      title: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
      onTap: onClicked,
    ),
  );
}

Widget readMoreButton(String text, bool isReadMore, {Color? color}) {
  return isReadMore == false
      ? ReadMoreText(
          text,
          trimCollapsedText: "Read more",
          trimExpandedText: "Read less",
          trimLength: 200,
          trimMode: TrimMode.Length,
          style: TextStyle(color: color ?? Colors.black87, fontSize: 16),
        )
      : const SizedBox.shrink();
}
