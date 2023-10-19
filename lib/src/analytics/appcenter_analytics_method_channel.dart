import 'package:meta/meta.dart';

import '../analytics.g.dart';
import 'appcenter_analytics_platform_interface.dart';

/// The method channel implementation of [AppCenterAnalyticsPlatformInterface].
class AppCenterAnalyticsMethodChannel
    extends AppCenterAnalyticsPlatformInterface {
  /// Creates a new [AppCenterAnalyticsMethodChannel] instance.
  factory AppCenterAnalyticsMethodChannel() =>
      AppCenterAnalyticsMethodChannel.internal(api: AnalyticsApi());

  /// Creates a new [AppCenterAnalyticsMethodChannel] instance for unit tests.
  @visibleForTesting
  AppCenterAnalyticsMethodChannel.internal({
    required final AnalyticsApi api,
  }) : _api = api;

  final AnalyticsApi _api;

  @override
  Future<void> trackEvent({
    required final String name,
    required final Map<String, String>? properties,
    required final int? flags,
  }) async {
    await _api.trackEvent(name, properties, flags);
  }

  @override
  Future<void> pause() async => _api.pause();

  @override
  Future<void> resume() async => _api.resume();

  @override
  Future<void> enable() async => _api.analyticsSetEnabled(true);

  @override
  Future<void> disable() async => _api.analyticsSetEnabled(false);

  @override
  Future<bool> isEnabled() async => _api.analyticsIsEnabled();

  @override
  Future<void> enableManualSessionTracker() async =>
      _api.enableManualSessionTracker();

  @override
  Future<void> startSession() async => _api.startSession();

  @override
  Future<bool> setTransmissionInterval(final int seconds) async =>
      _api.setTransmissionInterval(seconds);
}