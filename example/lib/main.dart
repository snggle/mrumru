import 'package:example/utils/router/router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CoreApp());
}

class CoreApp extends StatefulWidget {
  const CoreApp({super.key});

  @override
  State<StatefulWidget> createState() => _CoreAppState();
}

class _CoreAppState extends State<CoreApp> {
  final AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: appRouter.defaultRouteParser(),
      routerDelegate: appRouter.delegate(),
      debugShowCheckedModeBanner: false,
      builder: (_, Widget? routerWidget) {
        return routerWidget as Widget;
      },
    );
  }
}
