import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toy_world/screens/group_page.dart';
import 'package:toy_world/screens/home_page.dart';
import 'package:toy_world/screens/profile_page.dart';
import 'package:toy_world/utils/helpers.dart';

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

Widget defaultAppBar(BuildContext context) {
  var size = MediaQuery.of(context).size;
  return Center(
    child: Container(
      width: size.width,
      height: size.height * 0.1,
      color: const Color(0xffDB36A4),
      padding: const EdgeInsets.only(left: 5, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/icons/Logo_Word_Black_Pink.png",
              height: size.height * 0.08,
            ),
          ),
          SizedBox(
              width: size.width * 0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        shape: BoxShape.circle),
                    child: IconButton(
                      iconSize: size.height * 0.035,
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
                      iconSize: size.height * 0.035,
                      icon: const Icon(FontAwesomeIcons.commentDots,
                          color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ))
        ],
      ),
    ),
  );
}

Widget drawerMenu(BuildContext context, int role, String token, String name) {
  var size = MediaQuery.of(context).size;
  final urlImage =
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80';
  return SizedBox(
      width: size.width * 0.75,
      height: size.height,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(35), bottomLeft: Radius.circular(35)),
        child: Drawer(
          child: ListView(
            children: [
              buildHeader(
                urlImage: urlImage,
                name: name,
                onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                )),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildMenuItem(
                    text: 'Home',
                    urlImage: "assets/icons/home.png",
                    onClicked: () => selectedItem(context, 0, role, token),
                  ),
                  const Divider(
                    color: Color(0xffDB36A4),
                    thickness: 1,
                  ),
                  buildMenuItem(
                    text: 'Proposal',
                    urlImage: "assets/icons/proposal.png",
                    onClicked: () => selectedItem(context, 1, role, token),
                  ),
                  const Divider(
                    color: Color(0xffDB36A4),
                    thickness: 1,
                  ),
                  buildMenuItem(
                    text: 'Contest',
                    urlImage: "assets/icons/swords.png",
                    onClicked: () => selectedItem(context, 2, role, token),
                  ),
                  const Divider(
                    color: Color(0xffDB36A4),
                    thickness: 1,
                  ),
                  buildMenuItem(
                    text: 'Group',
                    urlImage: "assets/icons/group.png",
                    onClicked: () => selectedItem(context, 3, role, token),
                  ),
                  const Divider(
                    color: Color(0xffDB36A4),
                    thickness: 1,
                  ),
                  buildMenuItem(
                    text: 'Following',
                    urlImage: "assets/icons/followers.png",
                    onClicked: () => selectedItem(context, 4, role, token),
                  ),
                  const Divider(
                    color: Color(0xffDB36A4),
                    thickness: 1,
                  ),
                  buildMenuItem(
                    text: 'Toys',
                    urlImage: "assets/icons/toy.png",
                    onClicked: () => selectedItem(context, 5, role, token),
                  ),
                  const Divider(
                    color: Color(0xffDB36A4),
                    thickness: 1,
                  ),
                  buildMenuItem(
                    text: 'Sign out',
                    urlImage: "assets/icons/logout.png",
                    onClicked: () => selectedItem(context, 6, role, token),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
}

Widget menuHome(BuildContext context, int role, String token) {
  var size = MediaQuery.of(context).size;
  return SizedBox(
    width: size.width,
    height: size.height * 0.08,
    child: Container(
        alignment: Alignment.center,
        color: Colors.white,
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              iconSize: size.height * 0.045,
              alignment: Alignment.center,
              icon: Image.asset(
                "assets/icons/home.png",
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(
                          role: role,
                          token: token,
                        )));
              },
            ),
            IconButton(
              iconSize: size.height * 0.045,
              alignment: Alignment.center,
              icon: Image.asset(
                "assets/icons/group.png",
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GroupPage(
                          role: role,
                          token: token,
                        )));
              },
            ),
            IconButton(
              iconSize: size.height * 0.04,
              alignment: Alignment.center,
              icon: Image.asset(
                "assets/icons/swords.png",
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
            IconButton(
              iconSize: size.height * 0.045,
              alignment: Alignment.center,
              icon: Image.asset(
                "assets/icons/bell.png",
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
            IconButton(
              iconSize: size.height * 0.04,
              alignment: Alignment.center,
              icon: Image.asset(
                "assets/icons/3line_button.png",
                color: Colors.grey,
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ],
        )),
  );
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[500],
        ),
        child: Column(
          children: [
            CircleAvatar(radius: 40, backgroundImage: NetworkImage(urlImage)),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    padding: const EdgeInsets.only(left: 50, right: 10),
    child: ListTile(
      leading: SizedBox(
        height: 35,
        width: 35,
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
