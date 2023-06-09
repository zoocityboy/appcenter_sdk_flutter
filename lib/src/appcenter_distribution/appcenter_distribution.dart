import 'package:meta/meta.dart';

import 'appcenter_distribution_platform_interface.dart';

/// [AppCenterDistribution]
class AppCenterDistribution {
  @visibleForTesting
  // Because
  // ignore: avoid_setters_without_getters
  static set instance(AppCenterDistributionPlatformInterface instance) {
    AppCenterDistributionPlatformInterface.instance = instance;
  }

  ///
  static Stream<dynamic> onDistributeUpdateStream =
      AppCenterDistributionPlatformInterface.instance.onDistributeUpdateStream;

  ///
  static Future<void> setDistributeEnable({required bool value}) =>
      AppCenterDistributionPlatformInterface.instance
          .setDistributeEnable(value: value);

  ///
  static Future<void> setDistributeDebugEnable({required bool value}) =>
      AppCenterDistributionPlatformInterface.instance
          .setDistributeDebugEnable(value: value);

  ///
  static Future<bool> isDistributeEnabled() =>
      AppCenterDistributionPlatformInterface.instance.isDistributeEnabled();

  ///
  static Future<void> disableAutomaticCheckForUpdate() =>
      AppCenterDistributionPlatformInterface.instance
          .disableAutomaticCheckForUpdate();

  ///
  static Future<void> checkForUpdates() =>
      AppCenterDistributionPlatformInterface.instance.checkForUpdates();

  ///
  static Future<void> notifyDistributeUpdateAction({
    required int updateAction,
  }) =>
      AppCenterDistributionPlatformInterface.instance
          .notifyDistributeUpdateAction(updateAction: updateAction);

  ///
  static Future<void> handleDistributeUpdateAction({
    required int updateAction,
  }) =>
      AppCenterDistributionPlatformInterface.instance
          .handleDistributeUpdateAction(updateAction: updateAction);
}
