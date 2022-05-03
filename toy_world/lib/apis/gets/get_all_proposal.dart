import 'package:http/http.dart' as http;
import 'package:toy_world/models/model_proposal.dart';

import 'package:toy_world/utils/url.dart';

class AllProposalList {
  getAllProposal({token, size}) async {
    final queryParameters = {
      'PageNumber': "1",
      'PageSize': "$size",
    };

    var response = await http.get(Uri.https("$urlMain", "$urlGetAllProposal", queryParameters), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token',
    });

    print("Status getApi All Proposal:${response.statusCode}");
    if (response.statusCode == 200) {
      return proposalsFromJson(response.body);
    } else {
      return null;
    }
  }
}