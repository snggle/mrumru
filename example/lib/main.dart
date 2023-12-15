import 'package:example/page/mobile_page.dart';
import 'package:example/page/web_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CoreApp());
}

class CoreApp extends StatelessWidget {
  const CoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: const Text('Mru Mru Example App')),
          body: const WebPage(),
        ),
      );
    } else {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(title: const Text('Mru Mru Example App')),
            body: const MobilePage(),
          ));
    }
  }
}
