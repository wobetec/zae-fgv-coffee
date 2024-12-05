import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'device_id.dart';
import '../config.dart';

class FCM {
  static String? _deviceId;
  static String? _registrationId;

  static Future<void> initialize() async {
    await Firebase.initializeApp();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Set device ID
    _deviceId = await DeviceId.getId();

    // Set FCM token
    _registrationId = await FirebaseMessaging.instance.getToken(vapidKey: Config.vapidKey);
  }

  static String? get deviceId => _deviceId;
  static String? get registrationId => _registrationId;
}
