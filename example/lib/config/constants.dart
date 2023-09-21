// coverage:ignore-file

import 'dart:io';

import 'package:flutter/foundation.dart';

/// Load enviornmental variables from defintion `./env/env.xxx.json` in compile time
///
const bool kIsMock = bool.hasEnvironment('MOCK');
const kBaseUrl = String.fromEnvironment(
  'BASE_URL',
  defaultValue: 'http://localhos:9010/',
);
const kAppName = String.fromEnvironment('APP_NAME', defaultValue: 'Example');
const kAppSuffix = String.fromEnvironment('APP_SUFFIX', defaultValue: '.dev');
const kStage = String.fromEnvironment('STAGE', defaultValue: 'development');
final kAppCenterSecret = Platform.isIOS
    ? const String.fromEnvironment(
        'APP_CENTER_IOS_SECRET',
        defaultValue: 'b908f428-53a7-486a-a265-30a8df5ba12e',
      )
    : const String.fromEnvironment(
        'APP_CENTER_ANDROID_SECRET',
        defaultValue: '0bbc01a5-32e2-4d49-ba9b-10f1729ba3a7',
      );

/// Timeout
const kInitializationTimeout = Duration(seconds: 5);

/// Check if running on mobile
final isMobileTarget = [TargetPlatform.iOS, TargetPlatform.android]
    .contains(defaultTargetPlatform);

/// Check if running on desktop
final isDesktopTarget = [
  TargetPlatform.windows,
  TargetPlatform.macOS,
  TargetPlatform.linux,
].contains(defaultTargetPlatform);

const restorationScopeIdMain = 'app';
