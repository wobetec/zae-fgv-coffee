import 'package:http/http.dart';
import 'endpoint.dart';

class EndPointOrder extends EndPoint {
  Future<Response> getOrders(String token, {String? vmId}) async {
    final url = Uri.parse('${EndPoint.baseUrl}order/all');

    final response = await get(
      url,
      headers: headers(token),
    );
    return response;
  }

  Future<Response> getOrder(String token, String orderId) async {
    final url = Uri.parse('${EndPoint.baseUrl}order?order_id=$orderId');

    final response = await get(
      url,
      headers: headers(token),
    );
    return response;
  }
}