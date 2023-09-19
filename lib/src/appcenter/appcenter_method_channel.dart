import 'package:meta/meta.dart';

import '../appcenter.g.dart';
import 'appcenter_platform_interface.dart';

/// The method channel implementation of [AppCenterPlatformInterface].
class AppCenterMethodChannel extends AppCenterPlatformInterface {
  /// Creates a new [AppCenterMethodChannel] instance.
  factory AppCenterMethodChannel() =>
      AppCenterMethodChannel.internal(api: AppCenterApi());

  /// Creates a new [AppCenterMethodChannel] instance for unit tests.
  @visibleForTesting
  AppCenterMethodChannel.internal({required AppCenterApi api}) : _api = api;

  final AppCenterApi _api;

  @override
  Future<void> start({
    required String secret,
    bool usePrivateTrack = false,
  }) async =>
      _api.start(secret, usePrivateTrack);

  @override
  Future<void> setLogLevel(int value) => _api.setLogLevel(value);

  @override
  Future<void> enable() async => _api.setEnabled(true);

  @override
  Future<void> disable() async => _api.setEnabled(false);

  @override
  Future<bool> isEnabled() async => _api.isEnabled();

  @override
  Future<bool> isConfigured() async => _api.isConfigured();

  @override
  Future<String> getInstallId() async => _api.getInstallId();

  @override
  Future<bool> isRunningInAppCenterTestCloud() async =>
      _api.isRunningInAppCenterTestCloud();

}
