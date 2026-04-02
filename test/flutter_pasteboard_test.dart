import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pasteboard/flutter_pasteboard.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('pasteboard');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async => '42');
    expect(await FlutterPasteboard.platformVersion, '42');
  });

  test('image 调用 image 方法', () async {
    final imageData = Uint8List.fromList([1, 2, 3]);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      expect(call.method, 'image');
      return imageData;
    });
    final result = await FlutterPasteboard.image;
    expect(result, imageData);
  });

  test('writeImage 调用 writeImage 方法', () async {
    MethodCall? capturedCall;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      capturedCall = call;
      return null;
    });
    final imageBytes = Uint8List.fromList([4, 5, 6]);
    await FlutterPasteboard.writeImage(imageBytes, false);
    expect(capturedCall?.method, 'writeImage');
    expect(capturedCall?.arguments, isNotNull);
  });
}
