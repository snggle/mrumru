// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:example/page/extension.dart' as _i1;
import 'package:example/page/fullscreen.dart' as _i2;

abstract class $AppRouter extends _i3.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    ExtensionRoute.name: (routeData) {
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.ExtensionPage(),
      );
    },
    FullscreenRoute.name: (routeData) {
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.FullscreenPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.ExtensionPage]
class ExtensionRoute extends _i3.PageRouteInfo<void> {
  const ExtensionRoute({List<_i3.PageRouteInfo>? children})
      : super(
          ExtensionRoute.name,
          initialChildren: children,
        );

  static const String name = 'ExtensionRoute';

  static const _i3.PageInfo<void> page = _i3.PageInfo<void>(name);
}

/// generated route for
/// [_i2.FullscreenPage]
class FullscreenRoute extends _i3.PageRouteInfo<void> {
  const FullscreenRoute({List<_i3.PageRouteInfo>? children})
      : super(
          FullscreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'FullscreenRoute';

  static const _i3.PageInfo<void> page = _i3.PageInfo<void>(name);
}
