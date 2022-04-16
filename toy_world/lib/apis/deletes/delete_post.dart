import 'package:http/http.dart' as http;
import 'package:toy_world/utils/url.dart';

class DeletePost{
  deletePost({token, postId}) async{
    var response = await http.delete(
        Uri.https("$urlMain", "$urlDeletePost/$postId"),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          'Authorization': 'Bearer $token',
        });
    print("Status deleteApi Delete Post:${response.statusCode}");

    return response.statusCode;
  }
}