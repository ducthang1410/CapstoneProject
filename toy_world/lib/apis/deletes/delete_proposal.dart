import 'package:http/http.dart' as http;
import 'package:toy_world/utils/url.dart';

class DeleteProposal{
  deleteProposal({token, proposalId}) async{
    final queryParameters = {
      'proposalId': "$proposalId",
    };
    var response = await http.delete(
        Uri.https("$urlMain", "$urlDeleteProposal", queryParameters),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          'Authorization': 'Bearer $token',
        });
    print("Status deleteApi Delete Proposal:${response.statusCode}");

    return response.statusCode;
  }
}