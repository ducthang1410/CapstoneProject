import 'package:http/http.dart' as http;
import 'package:toy_world/utils/url.dart';

class DeleteContestPost{
  deleteContestPost({token, contestPostId}) async{
    var response = await http.delete(
        Uri.https("$urlMain", "$urlDeleteContestPost/$contestPostId"),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          'Authorization': 'Bearer $token',
        });
    print("Status deleteApi Delete Contest Post:${response.statusCode}");

    return response.statusCode;
  }
}