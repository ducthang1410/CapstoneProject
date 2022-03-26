import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullPhotoPage extends StatelessWidget {
  final String url;

  FullPhotoPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffDB36A4),
        title: const Text(
          "Photo",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: PhotoView(
        imageProvider: NetworkImage(url),
      ),
    );
  }
}
