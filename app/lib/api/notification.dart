import 'auth.dart';
import 'endpoints/endpoint_notification.dart';

class Notification {
  static EndPointNotification? _endPointNotification;

  static initialize(EndPointNotification? endPointNotification, {bool force = false}) {
    if (_endPointNotification == null || force) {
      _endPointNotification = endPointNotification;
    } else {
      _endPointNotification = EndPointNotification();
    }
  }

  static Future<void> registerDevice(String registrationId, String type, String deviceId) async {
    if (!Auth.hasToken()) {
      throw Exception('No token');
    }
    await _endPointNotification!.registerDevice(Auth.getToken()!, registrationId, type, deviceId)
      .then((response) {
        if (response.statusCode != 200) {
          throw Exception('Failed to register device');
        }
      })
      .catchError((error) {
        throw Exception('Failed to register device');
      });
  }
}