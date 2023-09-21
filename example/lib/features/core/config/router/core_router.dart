import 'package:go_router/go_router.dart';

import '../../presentation/pages/main_page.dart';

List<GoRoute> coreRouter = [
  GoRoute(
    path: MainPage.routePath,
    name: MainPage.routeName,
    builder: (context, state) {
      return MainPage(
        key: state.pageKey,
      );
    },
  ),
];
