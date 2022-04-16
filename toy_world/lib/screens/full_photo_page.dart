import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:toy_world/components/component.dart';

class FullPhotoPage extends StatefulWidget {
  int role;
  String token;
  String url;

  FullPhotoPage({required this.url, required this.role, required this.token});

  @override
  State<FullPhotoPage> createState() => _FullPhotoPageState();
}

class _FullPhotoPageState extends State<FullPhotoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          sideAppBar(context, widget.role, widget.token),
          Expanded(
            child: PhotoView(
              imageProvider: NetworkImage(widget.url),
            ),
          ),
        ],
      ),
    );
  }
}
