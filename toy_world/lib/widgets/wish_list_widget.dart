import 'package:flutter/material.dart';
import 'package:toy_world/apis/deletes/delete_wishlist.dart';
import 'package:toy_world/apis/gets/get_group_list.dart';
import 'package:toy_world/apis/posts/post_wishlist.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_account_profile.dart';
import 'package:toy_world/models/model_group.dart';

class WishListWidget extends StatefulWidget {
  int role;
  String token;
  List<WishList>? wishLists;

  WishListWidget({required this.role, required this.token, this.wishLists});

  @override
  State<WishListWidget> createState() => _WishListWidgetState();
}

class _WishListWidgetState extends State<WishListWidget> {
  List<Group>? data = [];
  final List<int> _initialCategories = [];
  final List<int> _selectedCategories = [];
  final List<int> _unSelectedCategories = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadWishList();
    getData();
  }

  getData() async {
    GroupList groups = GroupList();
    data = await groups.getListGroup(token: widget.token);
    if (data == null) return List.empty();
    setState(() {});
    return data;
  }

  loadWishList() {
    if (widget.wishLists != null || widget.wishLists!.isNotEmpty) {
      for (var wishList in widget.wishLists!) {
        int groupId = wishList.id!;
        _initialCategories.add(groupId);
        _selectedCategories.add(groupId);
      }
    } else {
      return;
    }
  }

  void _onCategorySelected(bool selected, groupId) {
    if (selected == true) {
      setState(() {
        _selectedCategories.add(groupId);
        _unSelectedCategories.remove(groupId);
      });
    } else {
      setState(() {
        _selectedCategories.remove(groupId);
        _unSelectedCategories.add(groupId);
      });
    }
  }

  checkSaveWishList() async {
    PostWishlist wishlists = PostWishlist();
    DeleteWishlist deleteWishlist = DeleteWishlist();
    for (var value in _initialCategories) {
      _selectedCategories.remove(value);
    }
    int status1 = await wishlists.postWishlist(
        token: widget.token, groupIds: _selectedCategories);
    int status2 = await deleteWishlist.deleteWishlist(
        token: widget.token, groupIds: _unSelectedCategories);
    if (status1 == 200 && status2 == 200) {
      Navigator.of(context).pop();
      setState(() {});
      loadingSuccess(status: "Save wishlist successful !!!");
    } else {
      loadingFail(status: "Failed :((((");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AlertDialog(
      title: const Text(
        "My Wishlist",
        style: TextStyle(color: Color(0xffDB36A4), fontSize: 30),
        textAlign: TextAlign.center,
      ),
      content: Stack(overflow: Overflow.visible, children: <Widget>[
        Positioned(
          right: -40.0,
          top: -100.0,
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
          width: size.width * 0.8,
          height: size.height * 0.5,
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                    itemCount: data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        value: _selectedCategories.contains(data![index].id),
                        onChanged: (selected) {
                          _onCategorySelected(selected!, data![index].id);
                        },
                        title: Text(data?[index].name ?? ""),
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Colors.grey.shade300,
                              ),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ))),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.black87, fontSize: 16.0),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
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
                                const Color(0xffDB36A4),
                              ),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ))),
                          child: const Text(
                            "Save",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                          onPressed: () {
                            checkSaveWishList();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
