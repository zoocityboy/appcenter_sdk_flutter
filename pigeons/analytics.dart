// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_positional_boolean_parameters, prefer-match-file-name

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/analytics.g.dart',
    swiftOut: 'ios/Classes/Analytics.g.swift',
    kotlinOut:
        'android/src/main/kotlin/zoo/cityboy/appcenter/analytics/Analytics.g.kt',
    kotlinOptions: KotlinOptions(package: 'zoo.cityboy.appcenter.analytics'),
    debugGenerators: true,
    copyrightHeader: 'pigeons/copyright.txt',
    dartPackageName: 'appcenter',
  ),
)
@HostApi(dartHostTestHandler: 'TestAppCenterAnalyticsApi')
abstract class AnalyticsApi {
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  void trackEvent(
    String name,
    Map<String, String>? properties,
    int? flags,
  );
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  void trackPage(String name, Map<String, String>? properties);
  void pause();
  void resume();
  @async
  void analyticsSetEnabled(bool enabled);
  @async
  bool analyticsIsEnabled();
  void enableManualSessionTracker();
  void startSession();
  bool setTransmissionInterval(int seconds);
}
