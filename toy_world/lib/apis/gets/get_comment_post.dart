import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_post_detail.dart';

import 'package:toy_world/utils/url.dart';

class CommentPostList {
  getCommentPost({token, postId}) async {
    var response = await http.get(Uri.https("$urlMain", "$urlGetCommentByPost/$postId/mobile"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Comment Of Post:${response.statusCode}");
    if (response.statusCode == 200) {
      return postDetailFromJson(response.body);
    } else {
      return null;
    }
  }
}