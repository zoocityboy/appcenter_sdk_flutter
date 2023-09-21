// ignore_for_file: public_member_api_docs, sort_constructors_first
// coverage:ignore-file

import 'dart:developer';

import 'package:eit_injection/eit_injection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../features/core/config/di/core_injection.dart';
import '../constants.dart';

late final GetIt locator;
Future<void> injection(WidgetsBinding binding) async {
  locator = GetIt.instance;
  final injection = Injection(
    (GetIt di) => {
      CoreInjection(di),
    },
    binding,
    di: locator,
    // ignore: avoid_redundant_argument_values
    useOverides: kIsMock,
  );
  await injection.prepare((locator) async {
    if (kDebugMode) {
      log('Enviornment');
      log('STAGE: $kStage');
      log('BASE_URL: $kBaseUrl');
      log('APP_NAME: $kAppName');
      log('APP_SUFFIX: $kAppSuffix');
      log('MOCK: $kIsMock');
      log('APP_CENTER_SECRET: $kAppCenterSecret');
    }
  });
  await injection.initialize();
}

Future<void> injectionWidgetTest(GetIt instance) async {
  locator = instance;
}
