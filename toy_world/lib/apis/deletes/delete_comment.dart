import 'package:http/http.dart' as http;
import 'package:toy_world/utils/url.dart';

class DeleteComment{
  deleteComment({token, commentId}) async{
    var response = await http.delete(
        Uri.https("$urlMain", "$urlDeleteComment/$commentId"),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          'Authorization': 'Bearer $token',
        });
    print("Status deleteApi Delete Comment:${response.statusCode}");
    return response.statusCode;
  }
}