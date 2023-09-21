// ignore_for_file: public_member_api_docs, sort_constructors_first
// coverage:ignore-file

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/core/config/router/core_router.dart';
import '../../features/core/presentation/pages/main_page.dart';
import '../constants.dart';

part 'router.guard.dart';
part 'router.listener.dart';
part 'router.observer.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  observers: navigationObservers,
  routes: [
    ...coreRouter,
  ],
  initialLocation: MainPage.routePath,
  debugLogDiagnostics: kDebugMode,
  restorationScopeId: restorationScopeIdMain,
  redirect: routeGuarder,
);
