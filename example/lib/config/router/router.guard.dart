part of 'router.dart';

/// Authorization guard
///
/// this guarderer disable redirection without permission
///
/// Splash Screen
/// - on the start of the app we are checking
///
/// - successfuly started dependencies and services
/// - if user is not logged in - redirect to login page
/// - if user is logged in - redirect to dashboard
FutureOr<String?> routeGuarder(
  BuildContext context,
  GoRouterState state,
) {
  return null;
}
