import 'package:example/page/receive_tab.dart';
import 'package:example/page/send_tab.dart';
import 'package:example/page/settings_tab.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mru Mru Example App'),
          bottom: const TabBar(
            tabs: <Tab>[
              Tab(text: 'Settings'),
              Tab(text: 'Send'),
              Tab(text: 'Receive'),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            SettingsTab(),
            SendTab(),
            ReceiveTab(),
          ],
        ),
      ),
    );
  }
}
