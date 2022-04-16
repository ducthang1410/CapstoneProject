import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class NumOfComment {
  getNumOfComment({token, postId}) async {
    var response = await http.get(Uri.https("$urlMain", "$urlGetNumOfComment/$postId/num_of_comment"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Num Of Comment:${response.statusCode}");
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      return 0;
    }
  }
}