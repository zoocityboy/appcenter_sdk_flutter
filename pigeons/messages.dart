// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_positional_boolean_parameters, prefer-match-file-name

import 'package:pigeon/pigeon.dart';

class AppCenterConfig {
  AppCenterConfig({
    this.crashEnabled = false,
    this.analyticsEnabled = false,
    this.distributeEnabled = false,
    this.usePrivateTrack = false,
    this.logLevel = 0,
    this.transmissionInterval = 0,
  });
  final bool crashEnabled;
  final bool analyticsEnabled;
  final bool distributeEnabled;
  final bool usePrivateTrack;
  final int logLevel;
  final int transmissionInterval;
}

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/messages.g.dart',
    swiftOut: 'ios/Classes/Messages.g.swift',
    kotlinOut: 'android/src/main/kotlin/zoo/cityboy/appcenter/Messages.g.kt',
    kotlinOptions: KotlinOptions(package: 'zoo.cityboy.appcenter'),
  ),
)
@HostApi()
abstract class AppCenterApi {
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  @async
  void start(String secret, bool usePrivateTrack);
  @async
  void setEnabled(bool enabled);
  @async
  bool isEnabled();
  bool isConfigured();
  @async
  String getInstallId();
  bool isRunningInAppCenterTestCloud();

  @async
  void setLogLevel(int level);

  @async
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  int fibonacci(int n);
}

@HostApi()
abstract class AppCenterAnalyticsApi {
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  void trackEvent(
    String name,
    Map<String, String>? properties,
    int? flags,
  );
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

@HostApi()
abstract class AppCenterCrashesApi {
  void generateTestCrash();
  @async
  bool hasReceivedMemoryWarningInLastSession();
  @async
  bool hasCrashedInLastSession();
  @async
  void crashesSetEnabled(bool enabled);
  @async
  bool crashesIsEnabled();
  void trackException(
    String message,
    String? type,
    String? stackTrace,
    Map<String, String>? properties,
  );
}

@HostApi()
abstract class AppCenterDistributionApi {
  @async
  void setDistributeEnabled(bool enabled);

  @async
  void notifyDistributeUpdateAction(int updateAction);

  @async
  void handleDistributeUpdateAction(int updateAction);

  @async
  void setDistributeDebugEnabled(bool enabled);

  @async
  bool isDistributeEnabled();

  @async
  void disableAutomaticCheckForUpdate();

  @async
  void checkForUpdates();
}
