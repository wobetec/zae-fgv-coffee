import 'package:http/http.dart';
import 'dart:convert';
import 'endpoint.dart';


class EndPointNotification extends EndPoint {
  Future<Response> registerDevice(String token, String registrationId, String type, String deviceId) async {
    final url = Uri.parse('${EndPoint.baseUrl}notification/register_device');

    final response = await post(
      url,
      headers: headers(token),
      body: jsonEncode({
        'registration_id': registrationId,
        'type': type,
        'device_id': deviceId,
      }),
    );
    return response;
  }
}