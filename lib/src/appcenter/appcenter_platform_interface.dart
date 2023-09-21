import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../appcenter.g.dart';
import 'appcenter_method_channel.dart';

/// The interface that implementations of `appcenter` must extend.
abstract class AppCenterPlatformInterface extends PlatformInterface {
  /// Create an instance.
  AppCenterPlatformInterface() : super(token: _token);

  static AppCenterPlatformInterface _instance = AppCenterMethodChannel();

  static final Object _token = Object();

  /// The current default [AppCenterPlatformInterface] instance.
  static AppCenterPlatformInterface get instance => _instance;

  static set instance(AppCenterPlatformInterface instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Configure the SDK with the list of services to start with an app secret
  /// parameter.
  ///
  /// This may be called only once per application process lifetime.
  ///
  /// [config] – A unique and secret key used to identify the application.
  Future<void> start({
    required AppCenterConfig config,
  }) async =>
      throw UnimplementedError('start has not been implemented.');

  /// Enable the SDK as a whole.
  Future<void> enable() async =>
      throw UnimplementedError('enable has not been implemented.');

  /// Disable the SDK as a whole.
  Future<void> disable() async =>
      throw UnimplementedError('disable has not been implemented.');

  /// Check whether the SDK is enabled or not as a whole.
  Future<bool> isEnabled() async =>
      throw UnimplementedError('isEnabled has not been implemented.');

  /// Check whether SDK has already been configured.
  ///
  /// Returns: true if configured, false otherwise.
  Future<bool> isConfigured() async =>
      throw UnimplementedError('isConfigured has not been implemented.');

  /// Get a unique installation identifier.
  ///
  /// The identifier is persisted until the application is uninstalled and
  /// installed again.
  ///
  /// This operation is performed in background as it accesses SharedPreferences
  /// and UUID.
  Future<String> getInstallId() async =>
      throw UnimplementedError('getInstallId has not been implemented.');

  /// Check whether app is running in App Center Test.
  ///
  /// Returns: true if running in App Center Test, false otherwise (and where no
  /// test dependencies in release).
  Future<bool> isRunningInAppCenterTestCloud() async =>
      throw UnimplementedError(
        'isRunningInAppCenterTestCloud has not been implemented.',
      );

  /// Set the user id
  ///
  Future<void> setUserId(String userId) async => throw UnimplementedError(
        'setUserId has not been implemented.',
      );

  /// Set the country code
  Future<void> setCountryCode(String countryCode) async =>
      throw UnimplementedError(
        'setCountryCode has not been implemented.',
      );

  /// Get the SDK version
  Future<String> getSdkVersion() async => throw UnimplementedError(
        'getSdkVersion has not been implemented.',
      );

  /// Set the network requests allowed
  Future<void> setNetworkRequestsEnable() async => throw UnimplementedError(
        'setNetworkRequestsEnable has not been implemented.',
      );

  /// Set the network requests allowed
  Future<void> setNetworkRequestsDisable() async => throw UnimplementedError(
        'setNetworkRequestsDisable has not been implemented.',
      );

  /// Check whether network requests are allowed
  Future<bool> isNetworkRequestsAllowed() async => throw UnimplementedError(
        'isNetworkRequestsAllowed has not been implemented.',
      );

  ///
  Future<void> setLogLevel(LoggerLevel value) async =>
      throw UnimplementedError('setLogLevel has not been implemented.');
}
