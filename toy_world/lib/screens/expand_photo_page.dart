import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:toy_world/components/component.dart';
import 'package:toy_world/models/model_image_post.dart';
import 'package:toy_world/utils/helpers.dart';

class ExpandPhotoPage extends StatefulWidget {
  int role;
  String token;
  List<ImagePost> images;

  ExpandPhotoPage(
      {required this.role, required this.token, required this.images});

  @override
  State<ExpandPhotoPage> createState() => _ExpandPhotoPageState();
}

class _ExpandPhotoPageState extends State<ExpandPhotoPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: Column(
        children: [
          sideAppBar(context, widget.role, widget.token),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  String? imageUrl = widget.images[index].url;
                  return Container(
                    color: Colors.black87,
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    child: GestureDetector(
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
                    ),
                  );
                  ;
                }),
          ),
        ],
      ),
    );
  }
}
