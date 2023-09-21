// ignore_for_file: avoid_print

import 'dart:async';

import 'package:appcenter_sdk/appcenter_sdk.dart';
import 'package:eit_injection/eit_injection.dart';

import '../../../../config/constants.dart';

class CoreInjection extends InjectableFeature {
  CoreInjection(super.locator);

  @override
  void register() {}

  @override
  Future<void> preRegister() async {
    await AppCenter.start(
      config: AppCenterConfig(
        secret: kAppCenterSecret,
        crashEnabled: true,
        analyticsEnabled: true,
        distributeEnabled: true,
        usePrivateTrack: false,
        logLevel: LoggerLevel.error,
        transmissionInterval: 10,
      ),
    );
    try {
      await Distribution.setDistributeEnable(value: true);
      // await AppCenter.setCountryCode('CS');
      unawaited(
        AppCenter.setCountryCode('CS').then((value) {
          print('setCountryCode: success');
        }).catchError((e, s) {
          print('setCountryCode failed: $e');
        }),
      );
      unawaited(
        AppCenter.setUserId('userId@appcenter.ms').then((value) {
          print('setUserId: success');
        }).catchError((e, s) {
          print('failed to setUserId: $e');
        }),
      );
      await Analytics.enable().then(
        (value) async {
          final enabled = await Analytics.isEnabled();
          print('Analytics enable:$enabled');
        },
      );
      await AppCenter.isRunningInAppCenterTestCloud().then(
        (value) => print('isRunningInAppCenterTestCloud: $value'),
      );
      await AppCenter.getInstallId().then(
        (value) => print('installId: $value'),
      );

      await Crashes.isEnabled().then(
        (value) => print('isEnabled: $value'),
      );
      await Crashes.hasCrashedInLastSession().then(
        (value) => print('hasCrashedInLastSession: $value'),
      );
      await Analytics.isEnabled().then(
        (value) => print('isEnabled: $value'),
      );
      await Analytics.setTransmissionInterval(10).then(
        (value) => print('setTransmissionInterval: $value'),
      );
      await Distribution.setDistributeDebugEnable(value: true).then(
        (value) => print('setDistributeDebugEnable: true'),
      );
    } catch (e) {
      print('failed to initialize: $e');
    }
    // await Distribution.checkForUpdates();
    return Future.value();
  }
}
