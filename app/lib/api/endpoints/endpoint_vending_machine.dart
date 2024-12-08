import 'package:http/http.dart';
import 'endpoint.dart';


class EndPointVendingMachine extends EndPoint {
  Future<Response> getVendingMachines(String token) async {
    final url = Uri.parse('${EndPoint.baseUrl}vending_machine');

    final response = await get(
      url,
      headers: headers(token),
    );
    return response;
  }
}