import 'package:http/http.dart';
import 'endpoint.dart';

class EndPointSimpleReport extends EndPoint {
  Future<Response> getSimpleReport(String token, String date) async {
    final url = Uri.parse('${EndPoint.baseUrl}report?date=$date');
    final response = await get(
      url,
      headers: headers(token),
    );
    return response;
  }
}
