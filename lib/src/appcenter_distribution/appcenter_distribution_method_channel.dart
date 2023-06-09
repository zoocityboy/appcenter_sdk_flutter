import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../messages.g.dart';
import 'appcenter_distribution_platform_interface.dart';

/// The method channel implementation of [AppCenterDistributionPlatformInterface].
class AppCenterDistributionMethodChannel
    extends AppCenterDistributionPlatformInterface {
  /// Creates a new [AppCenterDistributionMethodChannel] instance.
  factory AppCenterDistributionMethodChannel() =>
      AppCenterDistributionMethodChannel.internal(
        api: AppCenterDistributionApi(),
      );

  /// Creates a new [AppCenterDistributionMethodChannel] instance for unit tests.
  @visibleForTesting
  AppCenterDistributionMethodChannel.internal({
    required AppCenterDistributionApi api,
  })  : _api = api,
        _events = const EventChannel('zoo.cityboy.appcenter/distribute_events');

  final AppCenterDistributionApi _api;
  final EventChannel _events;
  @override
  Stream<dynamic> get onDistributeUpdateStream =>
      _events.receiveBroadcastStream();

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
    required int updateAction,
  }) =>
      _api.notifyDistributeUpdateAction(updateAction);

  @override
  Future<void> handleDistributeUpdateAction({required int updateAction}) =>
      _api.handleDistributeUpdateAction(updateAction);
}
