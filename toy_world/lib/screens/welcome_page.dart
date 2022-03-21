import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/screens/contest_page.dart';
import 'package:toy_world/screens/home_page.dart';
import 'package:toy_world/screens/list_group_page.dart';

class WelcomePage extends StatefulWidget {
  int role;
  String token;

  WelcomePage({required this.role, required this.token});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  String _avatar =
      "https://firebasestorage.googleapis.com/v0/b/toy-world-system.appspot.com/o/Avatar%2FdefaultAvatar.png?alt=media&token=b5fbfe09-9045-4838-bca5-649ff5667cad";
  String _name = "";
  int _selectedPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCounter();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatar = (prefs.getString('avatar') ?? "");
      _name = (prefs.getString('name') ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      endDrawer: drawerMenu(context, widget.role, widget.token, _name, _avatar),
      body: Builder(builder: (context) {
        return Column(
          children: [
            defaultAppBar(context),
            Container(
                height: size.height * 0.07,
                color: Colors.white,
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _tabButton(
                        Image.asset(
                          "assets/icons/home.png",
                          color: _selectColor(0, _selectedPage),
                        ),
                        _selectedPage,
                        0, function: () {
                      _changePage(0);
                    }),
                    _tabButton(
                        Image.asset(
                          "assets/icons/group.png",
                          color: _selectColor(1, _selectedPage),
                        ),
                        _selectedPage,
                        1, function: () {
                      _changePage(1);
                    }),
                    _tabButton(
                        Image.asset(
                          "assets/icons/swords.png",
                          color: _selectColor(2, _selectedPage),
                        ),
                        _selectedPage,
                        2, function: () {
                      _changePage(2);
                    }),
                    _tabButton(
                        Image.asset(
                          "assets/icons/bell.png",
                          color: _selectColor(3, _selectedPage),
                        ),
                        _selectedPage,
                        3, function: () {
                      _changePage(3);
                    }),
                    _tabButton(
                        Image.asset(
                          "assets/icons/3line_button.png",
                          color: _selectColor(4, _selectedPage),
                        ),
                        _selectedPage,
                        4, function: () {
                      Scaffold.of(context).openEndDrawer();
                    })
                  ],
                )),
            Expanded(
                child: PageView(
              controller: _pageController,
              children: [
                Center(
                  child: HomePage(
                    role: widget.role,
                    token: widget.token,
                  ),
                ),
                Center(
                  child: ListGroupPage(
                    role: widget.role,
                    token: widget.token,
                  ),
                ),
                const Center(
                  child: ContestPage(),
                ),
                const Center(
                  child: ContestPage(),
                ),
                const Center(),
              ],
            ))
          ],
        );
      }),
    );
  }

  Widget _tabButton(Image image, int selectedPage, int pageNumber, {function}) {
    var size = MediaQuery.of(context).size;
    return selectedPage == pageNumber
        ? Container(
            child: IconButton(
              iconSize: size.height * 0.04,
              alignment: Alignment.center,
              icon: image,
              onPressed: function,
            ),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(0xffDB36A4), width: 2.0))),
          )
        : IconButton(
            iconSize: size.height * 0.04,
            alignment: Alignment.center,
            icon: image,
            onPressed: function,
          );
  }

  _changePage(int pageNumber) {
    setState(() {
      _selectedPage = pageNumber;
      _pageController.animateToPage(pageNumber,
          duration: const Duration(microseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn);
    });
  }

  _selectColor(int index, int selectIndex) {
    if (index == selectIndex) {
      return const Color(0xffDB36A4);
    } else {
      return Colors.grey;
    }
  }
}
