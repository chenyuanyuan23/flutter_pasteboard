import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

class FlutterPasteboard {
  static const MethodChannel _channel = MethodChannel('pasteboard');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Returns the image data of the pasteboard.
  static Future<dynamic> get image async {
    // if (UniversalPlatform.isMacOS || UniversalPlatform.isLinux || UniversalPlatform.isIOS || UniversalPlatform.isWindows) {
    //   return await Pasteboard.image;
    // }
    final obj = await _channel.invokeMethod<Object>('image');

    return obj;
  }

  /// set image data to system pasteboard.
  static Future<void> writeImage(dynamic image, bool isGif) async {
    if (image == null) {
      return;
    }
    dynamic obj;
    String? path;
    if (image is File) {
      obj = image.readAsBytesSync();
      if (UniversalPlatform.isAndroid &&
          image.path.startsWith("/storage/emulated/0/Pictures")) {
        path = image.path;
      }
    } else {
      obj = image;
    }

    if (UniversalPlatform.isIOS) {
      await _channel.invokeMethod<void>(
          'writeImage', {'image': obj, "gif": isGif ? 1 : 0});
    } else if (path != null && path.isNotEmpty) {
      await _channel.invokeMethod<void>('writeImage', path);
    } else {
      await _channel.invokeMethod<void>('writeImage', obj);
    }
  }

  // /// Get files from system pasteboard.
  // static Future<List<String>> files() async {
  //   return await Pasteboard.files();
  // }

  // /// Set files to system pasteboard.
  // static Future<bool> writeFiles(List<String> files) async {
  //   return await Pasteboard.writeFiles(files);
  // }
}
