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
  Auth auth = Auth();
  Notification notification = Notification();

  group("Test registerDevice", (){
    test("Register device with correct token, registrationId, type and deviceId", () async {
      EndPointNotification endPointNotification = MockEndPointNotification();
      when(endPointNotification.registerDevice("123", "123", "android", "123")).thenAnswer((_) async => Response('{"message": "Device registered"}', 201));
      auth.initialize(EndPointAuth(), force: true);
      auth.setToken("123");
      notification.initialize(endPointNotification, force: true);

      await notification.registerDevice("123", "android", "123");
    });

    test("Register device with no token", () async {
      EndPointNotification endPointNotification = MockEndPointNotification();

      auth.initialize(EndPointAuth(), force: true, resetToken: true);
      notification.initialize(endPointNotification, force: true);

      expect(() async => await notification.registerDevice("123", "android", "123"), throwsException);
    });
  });
}