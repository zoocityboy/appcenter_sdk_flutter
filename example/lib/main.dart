// coverage:ignore-file

import 'app.dart';
import 'bootstrap.dart';
import 'config/di/injection.dart';

Future<void> main() async {
  await bootstrap(
    injection,
    () => const App(),
  );
}
