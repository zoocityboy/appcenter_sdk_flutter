import 'package:flutter_test/flutter_test.dart';
import 'package:appcenter_sdk/appcenter_sdk.dart';
import 'package:appcenter_sdk/appcenter_sdk_platform_interface.dart';
import 'package:appcenter_sdk/appcenter_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppcenterSdkPlatform
    with MockPlatformInterfaceMixin
    implements AppcenterSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AppcenterSdkPlatform initialPlatform = AppcenterSdkPlatform.instance;

  test('$MethodChannelAppcenterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppcenterSdk>());
  });

  test('getPlatformVersion', () async {
    AppcenterSdk appcenterSdkPlugin = AppcenterSdk();
    MockAppcenterSdkPlatform fakePlatform = MockAppcenterSdkPlatform();
    AppcenterSdkPlatform.instance = fakePlatform;

    expect(await appcenterSdkPlugin.getPlatformVersion(), '42');
  });
}
