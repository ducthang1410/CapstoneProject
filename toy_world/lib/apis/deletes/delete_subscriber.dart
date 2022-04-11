import 'package:http/http.dart' as http;
import 'package:toy_world/utils/url.dart';

class DeleteSubscriber{
  deleteSubscriber({token, contestId, accountId}) async{
    var response = await http.delete(
        Uri.https("$urlMain", "$urlDeleteSubscriber/$contestId/subscribers/$accountId"),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          'Authorization': 'Bearer $token',
        });
    print("Status deleteApi Delete Subscriber:${response.statusCode}");
    return response.statusCode;
  }
}