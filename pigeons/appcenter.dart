// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_positional_boolean_parameters, prefer-match-file-name

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/appcenter.g.dart',
    swiftOut: 'ios/Classes/Appcenter.g.swift',
    kotlinOut:
        'android/src/main/kotlin/zoo/cityboy/appcenter_sdk/appcenter/Appcenter.g.kt',
    kotlinOptions:
        KotlinOptions(package: 'zoo.cityboy.appcenter_sdk.appcenter'),
    debugGenerators: true,
    copyrightHeader: 'pigeons/copyright.txt',
    dartPackageName: 'appcenter_sdk',
  ),
)
@HostApi(dartHostTestHandler: 'TestAppCenterApi')
abstract class AppCenterApi {
  void start(AppCenterConfig config);
  @async
  void setEnabled(bool enabled);
  @async
  bool isEnabled();
  bool isConfigured();
  @async
  String getInstallId();
  bool isRunningInAppCenterTestCloud();

  @async
  void setUserId(String userId);

  @async
  void setCountryCode(String countryCode);

  String getSdkVersion();

  @async
  void setNetworkRequestsAllowed(bool enabled);
  bool isNetworkRequestsAllowed();

  void setLogLevel(LoggerLevel level);
}

class AppCenterConfig {
  AppCenterConfig(
    this.secret, {
    this.crashEnabled = false,
    this.analyticsEnabled = false,
    this.distributeEnabled = false,
    this.usePrivateTrack = false,
    this.logLevel = LoggerLevel.error,
    this.transmissionInterval = 0,
  });
  final String secret;
  final bool crashEnabled;
  final bool analyticsEnabled;
  final bool distributeEnabled;
  final bool usePrivateTrack;
  final LoggerLevel logLevel;
  final int transmissionInterval;
}

enum LoggerLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  fatal,
  none,
}
