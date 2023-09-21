// ignore_for_file: strict_raw_type

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../distribute.g.dart';
import 'appcenter_distribution_platform_interface.dart';

///
extension ReleaseDetailsParser on Map {
  ///
  ReleaseDetails tryParse() {
    return ReleaseDetails(
      id: this['id'] as int,
      version: this['version'] as int,
      size: this['size'] as int,
      shortVersion: this['shortVersion'] as String,
      releaseNotes: this['releaseNotes'] as String?,
      releaseNotesUrl: this['releaseNotesUrl'] as String?,
      minApiLevel: this['minApiLevel'] as int,
      downloadUrl: this['downloadUrl'] as String?,
      isMandatoryUpdate: this['isMandatoryUpdate'] as bool,
      releaseHash: this['releaseHash'] as String,
      distributionGroupId: this['distributionGroupId'] as String,
    );
  }
}

/// The method channel implementation of [AppCenterDistributionPlatformInterface].
class AppCenterDistributionMethodChannel
    extends AppCenterDistributionPlatformInterface {
  /// Creates a new [AppCenterDistributionMethodChannel] instance.
  factory AppCenterDistributionMethodChannel() =>
      AppCenterDistributionMethodChannel.internal(
        api: DistributeApi(),
      );

  /// Creates a new [AppCenterDistributionMethodChannel] instance for unit tests.
  @visibleForTesting
  AppCenterDistributionMethodChannel.internal({
    required DistributeApi api,
  })  : _api = api,
        _events =
            const EventChannel('zoo.cityboy.appcenter_sdk/distribute_events');

  final DistributeApi _api;
  final EventChannel _events;

  @override
  Stream<ReleaseDetails?> get onDistributeUpdateStream =>
      _events.receiveBroadcastStream().map(
        (event) {
          if (event != null && event is Map) {
            final converted = event.tryParse();
            return converted;
          }
          return null;
        },
      );

  @override
  Future<void> setDistributeEnable({required bool value}) =>
      _api.setDistributeEnabled(value);
  @override
  Future<void> setDistributeDebugEnable({required bool value}) =>
      _api.setDistributeDebugEnabled(value);
  @override
  Future<bool> isDistributeEnabled() => _api.isDistributeEnabled();

  @override
  Future<void> disableAutomaticCheckForUpdate() =>
      _api.disableAutomaticCheckForUpdate();

  @override
  Future<void> checkForUpdates() => _api.checkForUpdates();

  @override
  Future<void> notifyDistributeUpdateAction({
    required UpdateActionTap updateAction,
  }) =>
      _api.notifyDistributeUpdateAction(updateAction);

  @override
  Future<void> handleDistributeUpdateAction({
    required UpdateActionTap updateAction,
  }) =>
      _api.handleDistributeUpdateAction(updateAction);

  @override
  Future<ReleaseDetails?> ifExistsReleaseDetails() =>
      _api.ifExistsReleaseDetails();
}
