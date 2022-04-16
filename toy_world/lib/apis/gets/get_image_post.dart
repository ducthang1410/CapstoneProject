import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_image_post.dart';

import 'package:toy_world/utils/url.dart';

class ImagePostList {
  getImagePostList({token, postId}) async {
    var response = await http.get(Uri.https("$urlMain", "$urlGetImagePost/$postId/images"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Image Post:${response.statusCode}");
    if (response.statusCode == 200) {
      return imagesFromJson(response.body);
    } else {
      return <ImagePost>[];
    }
  }
}