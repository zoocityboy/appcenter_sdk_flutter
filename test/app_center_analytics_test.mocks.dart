// Mocks generated by Mockito 5.4.2 from annotations
// in appcenter/test/app_center_analytics_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:appcenter/src/analytics.g.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [AnalyticsApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockAnalyticsApi extends _i1.Mock implements _i2.AnalyticsApi {
  MockAnalyticsApi() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> trackEvent(
    String? arg_name,
    Map<String?, String?>? arg_properties,
    int? arg_flags,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #trackEvent,
          [
            arg_name,
            arg_properties,
            arg_flags,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> trackPage(
    String? arg_name,
    Map<String?, String?>? arg_properties,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #trackPage,
          [
            arg_name,
            arg_properties,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> pause() => (super.noSuchMethod(
        Invocation.method(
          #pause,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> resume() => (super.noSuchMethod(
        Invocation.method(
          #resume,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> analyticsSetEnabled(bool? arg_enabled) =>
      (super.noSuchMethod(
        Invocation.method(
          #analyticsSetEnabled,
          [arg_enabled],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<bool> analyticsIsEnabled() => (super.noSuchMethod(
        Invocation.method(
          #analyticsIsEnabled,
          [],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);
  @override
  _i3.Future<void> enableManualSessionTracker() => (super.noSuchMethod(
        Invocation.method(
          #enableManualSessionTracker,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> startSession() => (super.noSuchMethod(
        Invocation.method(
          #startSession,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<bool> setTransmissionInterval(int? arg_seconds) =>
      (super.noSuchMethod(
        Invocation.method(
          #setTransmissionInterval,
          [arg_seconds],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);
}
