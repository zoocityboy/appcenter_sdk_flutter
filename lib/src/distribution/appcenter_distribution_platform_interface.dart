import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../distribute.g.dart';
import 'appcenter_distribution_method_channel.dart';

/// The interface that implementations of `appcenter_crashes` must extend.
abstract class AppCenterDistributionPlatformInterface
    extends PlatformInterface {
  /// Create an instance.
  AppCenterDistributionPlatformInterface() : super(token: _token);

  static AppCenterDistributionPlatformInterface _instance =
      AppCenterDistributionMethodChannel();

  static final Object _token = Object();

  /// The current default [AppCenterDistributionPlatformInterface] instance.
  static AppCenterDistributionPlatformInterface get instance => _instance;

  static set instance(AppCenterDistributionPlatformInterface instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  ///
  Stream<ReleaseDetails?> get onDistributeUpdateStream =>
      throw UnimplementedError(
        'onDistributeUpdateAction has not been implemented.',
      );

  /// Enable Crashes service.
  Future<void> setDistributeEnable({required bool value}) async =>
      throw UnimplementedError('setEnable has not been implemented.');

  /// Disable Crashes service.
  Future<void> setDistributeDebugEnable({required bool value}) async =>
      throw UnimplementedError('setDebugEnable has not been implemented.');

  /// Check whether Crashes service is enabled or not.
  Future<bool> isDistributeEnabled() async =>
      throw UnimplementedError('isEnabled has not been implemented.');

  /// Check whether Crashes service is enabled or not.
  Future<void> disableAutomaticCheckForUpdate() async =>
      throw UnimplementedError(
        'setAutomaticCheckForUpdates has not been implemented.',
      );

  /// Check whether Crashes service is enabled or not.
  Future<void> checkForUpdates() async =>
      throw UnimplementedError('checkForUpdates has not been implemented.');

  ///
  Future<void> notifyDistributeUpdateAction({
    required UpdateActionTap updateAction,
  }) async =>
      throw UnimplementedError(
        'notifyDistributeUpdateAction has not been implemented.',
      );

  ///
  Future<void> handleDistributeUpdateAction({
    required UpdateActionTap updateAction,
  }) async =>
      throw UnimplementedError(
        'handleDistributeUpdateAction has not been implemented.',
      );

  ///
  Future<ReleaseDetails?> ifExistsReleaseDetails() async =>
      throw UnimplementedError(
        'ifExistsReleaseDetails has not been implemented.',
      );
}
