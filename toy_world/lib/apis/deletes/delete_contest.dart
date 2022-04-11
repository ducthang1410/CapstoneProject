import 'package:http/http.dart' as http;
import 'package:toy_world/utils/url.dart';

class DeleteContest{
  deleteContest({token, contestId}) async{
    var response = await http.delete(
        Uri.https("$urlMain", "$urlDeleteContest/$contestId"),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          'Authorization': 'Bearer $token',
        });
    print("Status deleteApi Delete Contest:${response.statusCode}");
    return response.statusCode;
  }
}