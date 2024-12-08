import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'device_id.dart';
import '../config.dart';
import 'package:namer_app/firebase_options.dart';


class FCM {
  static String? _deviceId;
  static String? _registrationId;
  static String? _deviceType;

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
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
    _deviceType = DeviceId.getDeviceType();

    // Set FCM token
    _registrationId = await FirebaseMessaging.instance.getToken(vapidKey: Config.vapidKey);
  }

  static String? get deviceId => _deviceId;
  static String? get registrationId => _registrationId;
  static String? get deviceType => _deviceType;
}
