// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_positional_boolean_parameters, prefer-match-file-name

import 'package:pigeon/pigeon.dart';

enum UpdateActionTap { postpone, update }

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/distribute.g.dart',
    swiftOut: 'ios/Classes/Distribute.g.swift',
    kotlinOut:
        'android/src/main/kotlin/zoo/cityboy/appcenter_sdk/distribute/Distribute.g.kt',
    kotlinOptions:
        KotlinOptions(package: 'zoo.cityboy.appcenter_sdk.distribute'),
    debugGenerators: true,
    copyrightHeader: 'pigeons/copyright.txt',
    dartPackageName: 'appcenter_sdk',
  ),
)
@HostApi(dartHostTestHandler: 'TestAppCenterDistributionApi')
abstract class DistributeApi {
  @async
  void setDistributeEnabled(bool enabled);

  @async
  void notifyDistributeUpdateAction(UpdateActionTap updateAction);

  @async
  void handleDistributeUpdateAction(UpdateActionTap updateAction);

  @async
  void setDistributeDebugEnabled(bool enabled);

  @async
  bool isDistributeEnabled();

  @async
  void disableAutomaticCheckForUpdate();

  @async
  void checkForUpdates();

  ReleaseDetails? ifExistsReleaseDetails();
}

class ReleaseDetails {
  ReleaseDetails(
    this.id,
    this.releaseHash,
    this.distributionGroupId, {
    required this.shortVersion, // @NonNull, required this.releaseHash, // @NonNull, required this.distributionGroupId, // @NonNull, this.id = 1,
    this.version = 1,
    this.size = 0,
    this.releaseNotes, // @Nullable
    this.releaseNotesUrl, // @Nullable
    this.minApiLevel = 0, // @NonNull
    this.downloadUrl, // @NonNull
    this.isMandatoryUpdate = false, // @NonNull
  });
  final int id;
  final int version;
  final int size;
  final String shortVersion;
  final String? releaseNotes;
  final String? releaseNotesUrl;
  final int minApiLevel;
  final String? downloadUrl;
  final bool isMandatoryUpdate;
  final String releaseHash;
  final String distributionGroupId;
}
