import 'package:meta/meta.dart';

import '../distribute.g.dart';
import 'appcenter_distribution_platform_interface.dart';

/// [Distribution]
class Distribution {
  @visibleForTesting
  // Because
  // ignore: avoid_setters_without_getters
  static set instance(AppCenterDistributionPlatformInterface instance) {
    AppCenterDistributionPlatformInterface.instance = instance;
  }

  ///
  static Stream<ReleaseDetails?> onDistributeUpdateStream =
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
  static Future<void> checkForUpdates() {
    return AppCenterDistributionPlatformInterface.instance.checkForUpdates();
  }

  ///
  static Future<void> notifyDistributeUpdateAction({
    required UpdateActionTap updateAction,
  }) =>
      AppCenterDistributionPlatformInterface.instance
          .notifyDistributeUpdateAction(updateAction: updateAction);

  ///
  static Future<void> handleDistributeUpdateAction({
    required UpdateActionTap updateAction,
  }) =>
      AppCenterDistributionPlatformInterface.instance
          .handleDistributeUpdateAction(updateAction: updateAction);

  ///
  static Future<ReleaseDetails?> ifExistsReleaseDetails() =>
      AppCenterDistributionPlatformInterface.instance.ifExistsReleaseDetails();
}
