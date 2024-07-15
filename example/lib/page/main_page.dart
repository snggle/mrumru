import 'package:example/cubit/receive_tab_cubit/receive_tab_cubit.dart';
import 'package:example/cubit/send_tab_cubit/send_tab_cubit.dart';
import 'package:example/cubit/settings_tab_cubit/settings_tab_cubit.dart';
import 'package:example/page/receive_tab.dart';
import 'package:example/page/send_tab.dart';
import 'package:example/page/settings_tab.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final SendTabCubit sendTabCubit = SendTabCubit();
  final ReceiveTabCubit receiveTabCubit = ReceiveTabCubit();
  final SettingsTabCubit settingsTabCubit = SettingsTabCubit();

  @override
  void dispose() {
    sendTabCubit.close();
    receiveTabCubit.close();
    super.dispose();
  }

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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: TabBarView(
            children: <Widget>[
              SettingsTab(sendTabCubit: sendTabCubit, receiveTabCubit: receiveTabCubit, settingsTabCubit: settingsTabCubit),
              SendTab(sendTabCubit: sendTabCubit),
              ReceiveTab(receiveTabCubit: receiveTabCubit),
            ],
          ),
        ),
      ),
    );
  }
}
