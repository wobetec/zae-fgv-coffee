import 'auth.dart';
import 'endpoints/endpoint_notification.dart';

class Notification {
  EndPointNotification? _endPointNotification;

  Notification._privateConstructor();

  static final Notification _instance = Notification._privateConstructor();

  factory Notification() {
    return _instance;
  }

  initialize(EndPointNotification? endPointNotification, {bool force = false}) {
    if (_endPointNotification == null || force) {
      _endPointNotification = endPointNotification;
    } else {
      _endPointNotification = EndPointNotification();
    }
  }

  Future<void> registerDevice(String registrationId, String type, String deviceId) async {
    Auth auth = Auth();
    if (!auth.hasToken()) {
      throw Exception('No token');
    }
    await _endPointNotification!.registerDevice(auth.getToken()!, registrationId, type, deviceId)
      .then((response) {
        if (response.statusCode != 201) {
          throw Exception('Failed to register device');
        }
      })
      .catchError((error) {
        throw Exception('Failed to register device');
      });
  }
}