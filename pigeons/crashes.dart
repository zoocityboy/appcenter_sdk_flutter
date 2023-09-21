// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_positional_boolean_parameters, prefer-match-file-name

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/crashes.g.dart',
    swiftOut: 'ios/Classes/Crashes.g.swift',
    kotlinOut:
        'android/src/main/kotlin/zoo/cityboy/appcenter_sdk/crashes/Crashes.g.kt',
    kotlinOptions: KotlinOptions(package: 'zoo.cityboy.appcenter_sdk.crashes'),
    debugGenerators: true,
    copyrightHeader: 'pigeons/copyright.txt',
    dartPackageName: 'appcenter_sdk',
  ),
)
@HostApi(dartHostTestHandler: 'TestAppCenterCrashesApi')
abstract class CrashesApi {
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
