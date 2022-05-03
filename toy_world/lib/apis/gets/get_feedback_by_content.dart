import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_feedback.dart';

import 'package:toy_world/utils/url.dart';

class FeedbackByContentList {
  getFeedbackByContent({token, content, size}) async {
    final queryParameters = {
      'PageNumber': "1",
      'PageSize': "$size",
    };

    var response = await http.get(Uri.https("$urlMain", "$urlGetFeedbackByContent/$content", queryParameters), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi Feedback By Content:${response.statusCode}");
    if (response.statusCode == 200) {
      return feedbackModelsFromJson(response.body);
    } else {
      return null;
    }
  }
}