import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:uuid/uuid.dart';

class DeviceId {
  static Future<String?> getId() async {
    if (kIsWeb) {
      final uuid = html.window.localStorage['deviceId'];
      if (uuid != null) {
        return uuid;
      }
      final newUuid = const Uuid().v4();
      html.window.localStorage['deviceId'] = newUuid;
      return newUuid;
    } else {
      if (Platform.isAndroid) {
        const androidIdPlugin = AndroidId();
        final String? androidId = await androidIdPlugin.getId();
        return androidId;
      } else if (Platform.isIOS) {
        final deviceInfo = DeviceInfoPlugin();
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor; // Unique ID on iOS
      } else if (Platform.isLinux) {
        final deviceInfo = DeviceInfoPlugin();
        final linuxInfo = await deviceInfo.linuxInfo;
        return linuxInfo.machineId; // Machine ID on Linux
      } else if (Platform.isMacOS) {
        final deviceInfo = DeviceInfoPlugin();
        final macInfo = await deviceInfo.macOsInfo;
        return macInfo.systemGUID; // System GUID on macOS
      } else if (Platform.isWindows) {
        final deviceInfo = DeviceInfoPlugin();
        final windowsInfo = await deviceInfo.windowsInfo;
        return windowsInfo.deviceId; // Unique ID on Windows
      } else {
        throw Exception('Platform not implemented');
      }
    }
  }
}