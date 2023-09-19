// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_positional_boolean_parameters, prefer-match-file-name

import 'package:pigeon/pigeon.dart';

class AppCenterConfig {
  const AppCenterConfig({
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
    dartOut: 'lib/src/appcenter.g.dart',
    swiftOut: 'ios/Classes/AppCenter.g.swift',
    kotlinOut:
        'android/src/main/kotlin/zoo/cityboy/appcenter/appcenter/AppCenter.g.kt',
    kotlinOptions: KotlinOptions(package: 'zoo.cityboy.appcenter.appcenter'),
    debugGenerators: true,
    copyrightHeader: 'pigeons/copyright.txt',
    dartPackageName: 'appcenter',
  ),
)
@HostApi(dartHostTestHandler: 'TestAppCenterApi')
abstract class AppCenterApi {
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
}
