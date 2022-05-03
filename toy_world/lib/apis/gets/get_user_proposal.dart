import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_proposal.dart';

import 'package:toy_world/utils/url.dart';

class UserProposal {
  getUserProposal({token, accountId}) async {

    var response = await http.get(Uri.https("$urlMain", "$urlGetUserProposal/$accountId"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi User Proposal:${response.statusCode}");
    if (response.statusCode == 200) {
      return proposalFromJson(response.body);
    } else {
      return null;
    }
  }
}