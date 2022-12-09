import 'package:appcenter_sdk_flutter/src/appcenter_analytics/appcenter_analytics_platform_interface.dart';
import 'package:appcenter_sdk_flutter/src/messages.g.dart';

/// MethodChannelAppCenterAnalytics
class MethodChannelAppCenterAnalytics extends AppCenterAnalyticsPlatform {
  final AppCenterAnalyticsApi _api = AppCenterAnalyticsApi();

  @override
  Future<void> trackEvent(
    final String name,
    final Map<String, String>? properties,
    final int? flags,
  ) async {
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