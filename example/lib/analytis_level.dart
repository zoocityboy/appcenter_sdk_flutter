import 'package:meta/meta.dart';

/// Severity of the logged [Event].
@immutable
class AnalyticsLevel {
  const AnalyticsLevel._(this.name, this.ordinal);

  static const fatal = AnalyticsLevel._('fatal', 5);
  static const error = AnalyticsLevel._('error', 4);
  static const warning = AnalyticsLevel._('warning', 3);
  static const info = AnalyticsLevel._('info', 2);
  static const debug = AnalyticsLevel._('debug', 1);

  /// API name of the level as it is encoded in the JSON protocol.
  final String name;
  final int ordinal;

  factory AnalyticsLevel.fromName(String name) {
    switch (name) {
      case 'fatal':
        return AnalyticsLevel.fatal;
      case 'error':
        return AnalyticsLevel.error;
      case 'warning':
        return AnalyticsLevel.warning;
      case 'info':
        return AnalyticsLevel.info;
    }
    return AnalyticsLevel.debug;
  }

  /// For use with Dart's
  /// [`log`](https://api.dart.dev/stable/2.12.4/dart-developer/log.html)
  /// function.
  /// These levels are inspired by
  /// https://pub.dev/documentation/logging/latest/logging/Level-class.html
  int toDartLogLevel() {
    switch (this) {
      // Level.SHOUT
      case AnalyticsLevel.fatal:
        return 1200;
      // Level.SEVERE
      case AnalyticsLevel.error:
        return 1000;
      // Level.SEVERE
      case AnalyticsLevel.warning:
        return 900;
      // Level.INFO
      case AnalyticsLevel.info:
        return 800;
      // Level.CONFIG
      case AnalyticsLevel.debug:
        return 700;
    }
    return 700;
  }
}
