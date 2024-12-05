import "package:namer_app/api/auth.dart";
import "package:namer_app/api/endpoints/endpoint_auth.dart";

import "package:namer_app/api/notification.dart";
import "package:namer_app/api/endpoints/endpoint_notification.dart";

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart';
import 'notification_test.mocks.dart';


@GenerateMocks([EndPointNotification])
void main(){
  group("Test registerDevice", (){
    test("Register device with correct token, registrationId, type and deviceId", () async {
      EndPointNotification endPointNotification = MockEndPointNotification();
      when(endPointNotification.registerDevice("123", "123", "android", "123")).thenAnswer((_) async => Response('{"message": "Device registered"}', 200));
      Auth.initialize(EndPointAuth(), force: true);
      Auth.setToken("123");
      Notification.initialize(endPointNotification, force: true);

      await Notification.registerDevice("123", "android", "123");
    });

    test("Register device with no token", () async {
      EndPointNotification endPointNotification = MockEndPointNotification();

      Auth.initialize(EndPointAuth(), force: true, resetToken: true);
      Notification.initialize(endPointNotification, force: true);

      expect(() async => await Notification.registerDevice("123", "android", "123"), throwsException);
    });
  });
}