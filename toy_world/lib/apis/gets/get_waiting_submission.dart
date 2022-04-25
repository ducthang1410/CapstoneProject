import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_waiting_submission.dart';

import 'package:toy_world/utils/url.dart';

class WaitingSubmissionList {
  getWaitingSubmission({token, contestId, size}) async {
    final queryParameters = {
      'PageNumber': "1",
      'PageSize': "$size",
    };
    var response = await http.get(Uri.https("$urlMain", "$urlGetWaitingSubmission/$contestId/mobile", queryParameters), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Waiting Submission:${response.statusCode}");
    if (response.statusCode == 200) {
      return waitingSubmissionsFromJson(response.body);
    } else {
      return null;
    }
  }
}