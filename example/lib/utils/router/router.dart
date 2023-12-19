import 'package:auto_route/auto_route.dart';
import 'package:example/utils/router/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes {
    return <AutoRoute>[
      AutoRoute(page: ExtensionRoute.page, initial: true, path: '/extension'),
      AutoRoute(page: FullscreenRoute.page, path: '/main'),
    ];
  }
}
