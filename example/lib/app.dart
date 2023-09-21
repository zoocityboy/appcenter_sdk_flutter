// coverage:ignore-file

import 'package:eit_uikit/eit_uikit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'config/constants.dart';
import 'config/router/router.dart';
import 'features/core/presentation/theme/theme.dart';

final scaffoldGlobalKey = GlobalKey<ScaffoldMessengerState>();
final theme = EitTheme();

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: scaffoldGlobalKey,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: router,
      scrollBehavior: isDesktopTarget
          ? const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.stylus,
                PointerDeviceKind.unknown,
              },
            )
          : const MaterialScrollBehavior(),
    );
  }
}
