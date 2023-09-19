import 'package:appcenter/appcenter.dart';
import 'package:appcenter/src/crashes.g.dart';
import 'package:appcenter/src/crashes/appcenter_crashes_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_center_crashes_test.mocks.dart';

@GenerateMocks([CrashesApi])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'AppCenterCrashes',
    () {
      late final CrashesApi api;
      setUpAll(() {
        api = MockCrashesApi();
        Crashes.instance = AppCenterCrashesMethodChannel.internal(api: api);
      });
      test('generateTestCrash', () async {
        when(api.generateTestCrash())
            .thenAnswer((_) async => Future<void>.value());

        await Crashes.generateTestCrash();

        verify(api.generateTestCrash()).called(1);
      });

      test('hasReceivedMemoryWarningInLastSession return true', () async {
        const expected = true;
        when(api.hasReceivedMemoryWarningInLastSession())
            .thenAnswer((_) async => expected);

        final value = await Crashes.hasReceivedMemoryWarningInLastSession();

        expect(value, expected);
        verify(api.hasReceivedMemoryWarningInLastSession()).called(1);
      });

      test('hasReceivedMemoryWarningInLastSession return false', () async {
        const expected = false;
        when(api.hasReceivedMemoryWarningInLastSession())
            .thenAnswer((_) async => expected);

        final value = await Crashes.hasReceivedMemoryWarningInLastSession();

        expect(value, expected);
        verify(api.hasReceivedMemoryWarningInLastSession()).called(1);
      });

      test('hasCrashedInLastSession return true', () async {
        const expected = true;
        when(api.hasCrashedInLastSession()).thenAnswer((_) async => expected);

        final value = await Crashes.hasCrashedInLastSession();

        expect(value, expected);
        verify(api.hasCrashedInLastSession()).called(1);
      });

      test('hasCrashedInLastSession return false', () async {
        const expected = false;
        when(api.hasCrashedInLastSession()).thenAnswer((_) async => expected);

        final value = await Crashes.hasCrashedInLastSession();

        expect(value, expected);
        verify(api.hasCrashedInLastSession()).called(1);
      });

      test('enable', () async {
        when(api.crashesSetEnabled(true))
            .thenAnswer((_) async => Future<void>.value());

        await Crashes.enable();

        verify(api.crashesSetEnabled(true)).called(1);
      });

      test('disable', () async {
        when(api.crashesSetEnabled(true))
            .thenAnswer((_) async => Future<void>.value());

        await Crashes.disable();

        verify(api.crashesSetEnabled(false)).called(1);
      });

      test('isEnabled return true', () async {
        const expected = true;
        when(api.crashesIsEnabled()).thenAnswer((_) async => expected);

        final value = await Crashes.isEnabled();

        expect(value, expected);
        verify(api.crashesIsEnabled()).called(1);
      });

      test('isEnabled return false', () async {
        const expected = false;
        when(api.crashesIsEnabled()).thenAnswer((_) async => expected);
        Crashes.instance = AppCenterCrashesMethodChannel.internal(api: api);

        final value = await Crashes.isEnabled();

        expect(value, expected);
        verify(api.crashesIsEnabled()).called(1);
      });

      test('trackException', () async {
        when(api.trackException('any', any, any, any))
            .thenAnswer((_) async => Future<void>.value());

        final exception = Exception('Message');
        const stackTraceString = 'I am a stack trace.';
        await Crashes.trackException(
          message: exception.toString(),
          type: exception.runtimeType,
          stackTrace: StackTrace.fromString(stackTraceString),
          properties: {'Property': 'Value'},
        );

        verify(
          api.trackException(
            exception.toString(),
            exception.runtimeType.toString(),
            stackTraceString,
            {'Property': 'Value'},
          ),
        ).called(1);
      });
    },
  );
}
