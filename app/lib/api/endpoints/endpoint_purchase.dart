import 'package:http/http.dart';
import 'dart:convert';
import 'endpoint.dart';


class EndPointPurchase extends EndPoint {
  Future<Response> purchase(String token, String vmId, List<dynamic> products) async {
    final url = Uri.parse('${EndPoint.baseUrl}purchase');

    final response = await post(
      url,
      headers: headers(token),
      body: jsonEncode({
        'vm_id': vmId,
        'products': products,
      }),
    );
    return response;
  }
}