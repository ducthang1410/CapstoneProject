
import 'package:http/http.dart' as http;

import 'package:toy_world/utils/url.dart';

class ApproveDenyWaitingSubmission{
  approveDenyWaitingSubmission({token, submissionId, choice}) async {
    final response = await http.put(
      Uri.https('$urlMain', '$urlPutApproveDenySubmission/$submissionId/$choice'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token',
      },
    );
    print("Status putApi Approve/Deny Waiting Submission:${response.statusCode}");

    return response.statusCode;
  }
}