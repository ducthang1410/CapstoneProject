import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:toy_world/components/component.dart';

class FullPhotoPage extends StatelessWidget {
  final String url;

  FullPhotoPage({required this.url});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        overflow: Overflow.visible,
        children: [
          PhotoView(
            imageProvider: NetworkImage(url),
          ),
          Positioned(top: -5, child: groupAppBar(context)),
        ],
      ),
    );
  }
}
