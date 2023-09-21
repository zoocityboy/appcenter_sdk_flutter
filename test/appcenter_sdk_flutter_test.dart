import 'package:flutter_test/flutter_test.dart';
import 'package:appcenter_sdk_flutter/appcenter_sdk_flutter.dart';
import 'package:appcenter_sdk_flutter/appcenter_sdk_flutter_platform_interface.dart';
import 'package:appcenter_sdk_flutter/appcenter_sdk_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppcenterSdkFlutterPlatform
    with MockPlatformInterfaceMixin
    implements AppcenterSdkFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AppcenterSdkFlutterPlatform initialPlatform = AppcenterSdkFlutterPlatform.instance;

  test('$MethodChannelAppcenterSdkFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppcenterSdkFlutter>());
  });

  test('getPlatformVersion', () async {
    AppcenterSdkFlutter appcenterSdkFlutterPlugin = AppcenterSdkFlutter();
    MockAppcenterSdkFlutterPlatform fakePlatform = MockAppcenterSdkFlutterPlatform();
    AppcenterSdkFlutterPlatform.instance = fakePlatform;

    expect(await appcenterSdkFlutterPlugin.getPlatformVersion(), '42');
  });
}
