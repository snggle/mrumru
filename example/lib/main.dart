import 'package:example/page/example_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CoreApp());
}

class CoreApp extends StatelessWidget {
  const CoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Mru Mru Example App')),
        body: const ExamplePage(),
      ),
    );
  }
}
