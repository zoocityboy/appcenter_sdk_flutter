import 'package:appcenter/appcenter.dart';
import 'package:appcenter/src/analytics.g.dart';
import 'package:appcenter/src/analytics/appcenter_analytics_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_center_analytics_test.mocks.dart';

@GenerateMocks([AnalyticsApi])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'AppCenterAnalytics',
    () {
      late AnalyticsApi api;
      setUpAll(() {
        api = MockAnalyticsApi();
        Analytics.instance = AppCenterAnalyticsMethodChannel.internal(api: api);
      });
      test('trackEvent', () async {
        when(api.trackEvent('Name', {'Property': 'Value'}, 1))
            .thenAnswer((_) async => Future<void>);

        await Analytics.trackEvent(
          name: 'Name',
          properties: {'Property': 'Value'},
          flags: 1,
        );

        verify(api.trackEvent('Name', {'Property': 'Value'}, 1)).called(1);
      });

      test('pause', () async {
        when(api.pause()).thenAnswer((_) async => Future<void>.value);

        await Analytics.pause();

        verify(api.pause()).called(1);
      });

      test('resume', () async {
        when(api.resume()).thenAnswer((_) async => Future<void>.value);
        await Analytics.resume();

        verify(api.resume()).called(1);
      });

      test('enable', () async {
        when(api.analyticsSetEnabled(true))
            .thenAnswer((_) async => Future<void>);

        await Analytics.enable();

        verify(api.analyticsSetEnabled(true)).called(1);
      });

      test('disable', () async {
        when(api.analyticsSetEnabled(true))
            .thenAnswer((_) async => Future<void>);

        await Analytics.disable();

        verify(api.analyticsSetEnabled(false)).called(1);
      });

      test('isEnabled return true', () async {
        const expected = true;
        when(api.analyticsIsEnabled()).thenAnswer((_) async => expected);

        final value = await Analytics.isEnabled();

        expect(value, expected);
        verify(api.analyticsIsEnabled()).called(1);
      });

      test('isEnabled return false', () async {
        const expected = false;
        when(api.analyticsIsEnabled()).thenAnswer((_) async => expected);

        final value = await Analytics.isEnabled();

        expect(value, expected);
        verify(api.analyticsIsEnabled()).called(1);
      });

      test('enableManualSessionTracker', () async {
        when(api.enableManualSessionTracker())
            .thenAnswer((_) async => Future<void>);

        await Analytics.enableManualSessionTracker();

        verify(api.enableManualSessionTracker()).called(1);
      });

      test('startSession', () async {
        when(api.startSession()).thenAnswer((_) async => Future<void>.value());

        await Analytics.startSession();

        verify(api.startSession()).called(1);
      });

      test('setTransmissionInterval', () async {
        const expected = true;
        const seconds = 3;

        when(api.setTransmissionInterval(seconds))
            .thenAnswer((_) async => expected);

        final value = await Analytics.setTransmissionInterval(seconds);

        expect(value, expected);
        verify(api.setTransmissionInterval(seconds)).called(1);
      });
    },
  );
}
