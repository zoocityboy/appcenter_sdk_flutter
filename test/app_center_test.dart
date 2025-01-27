import 'package:appcenter/appcenter.dart';
import 'package:appcenter/src/appcenter.g.dart';
import 'package:appcenter/src/appcenter/appcenter_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_center_test.mocks.dart';

@GenerateMocks([AppCenterApi])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'AppCenter',
    () {
      late AppCenterApi api;
      setUpAll(() {
        api = MockAppCenterApi();
        AppCenter.instance = AppCenterMethodChannel.internal(api: api);
      });

      test('start', () async {
        when(api.start('APP-SECRET', false))
            .thenAnswer((_) async => Future<void>.value());

        await AppCenter.start(secret: 'APP-SECRET', usePrivateTrack: false);

        verify(api.start('APP-SECRET', false)).called(1);
      });

      test('enable', () async {
        when(api.setEnabled(true)).thenAnswer((_) async => Future<void>);

        await AppCenter.enable();

        verify(api.setEnabled(true)).called(1);
      });

      test('disable', () async {
        when(api.setEnabled(false)).thenAnswer((_) async => Future<void>);

        await AppCenter.disable();

        verify(api.setEnabled(false)).called(1);
      });

      test('isEnabled return true', () async {
        const expected = true;
        when(api.isEnabled()).thenAnswer((_) async => expected);

        final value = await AppCenter.isEnabled();

        expect(value, expected);
        verify(api.isEnabled()).called(1);
      });

      test('isEnabled return false', () async {
        const expected = false;
        when(api.isEnabled()).thenAnswer((_) async => expected);

        final value = await AppCenter.isEnabled();

        expect(value, expected);
        verify(api.isEnabled()).called(1);
      });

      test('isConfigured return true', () async {
        const expected = true;
        when(api.isConfigured()).thenAnswer((_) async => expected);

        final value = await AppCenter.isConfigured();

        expect(value, expected);
        verify(api.isConfigured()).called(1);
      });

      test('isConfigured return false', () async {
        const expected = true;
        when(api.isConfigured()).thenAnswer((_) async => expected);

        final value = await AppCenter.isConfigured();

        expect(value, expected);
        verify(api.isConfigured()).called(1);
      });

      test('getInstallId', () async {
        const expected = 'InstallId';
        when(api.getInstallId()).thenAnswer((_) async => expected);

        final value = await AppCenter.getInstallId();

        expect(value, expected);
        verify(api.getInstallId()).called(1);
      });

      test('isRunningInAppCenterTestCloud return true', () async {
        const expected = true;
        when(api.isRunningInAppCenterTestCloud())
            .thenAnswer((_) async => expected);

        final value = await AppCenter.isRunningInAppCenterTestCloud();

        expect(value, expected);
        verify(api.isRunningInAppCenterTestCloud()).called(1);
      });

      test('isRunningInAppCenterTestCloud return false', () async {
        final api = MockAppCenterApi();
        const expected = false;
        when(api.isRunningInAppCenterTestCloud())
            .thenAnswer((_) async => expected);
        AppCenter.instance = AppCenterMethodChannel.internal(api: api);

        final value = await AppCenter.isRunningInAppCenterTestCloud();

        expect(value, expected);
        verify(api.isRunningInAppCenterTestCloud()).called(1);
      });
    },
  );
}
