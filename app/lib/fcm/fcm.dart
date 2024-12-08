import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'device_id.dart';
import '../config.dart';
import 'package:namer_app/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FCM {
  String? _deviceId;
  String? _registrationId;
  String? _deviceType;

  FCM._privateConstructor();

  static final FCM _instance = FCM._privateConstructor();

  factory FCM() {
    return _instance;
  }

  Future<void> initialize() async {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('deviceId') == null) {
      _deviceId = await DeviceId.getId();
    } else {
      _deviceId = prefs.getString('deviceId');
    }
    _deviceType = DeviceId.getDeviceType();

    // Set FCM token
    _registrationId = await FirebaseMessaging.instance.getToken(vapidKey: Config.vapidKey);
  }

  String? get deviceId => _deviceId;
  String? get registrationId => _registrationId;
  String? get deviceType => _deviceType;
}
