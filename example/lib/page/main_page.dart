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

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  final SettingsTabCubit settingsTabCubit = SettingsTabCubit();
  final SendTabCubit sendTabCubit = SendTabCubit();
  final ReceiveTabCubit receiveTabCubit = ReceiveTabCubit();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabChange)
      ..dispose();
    settingsTabCubit.close();
    sendTabCubit.close();
    receiveTabCubit.close();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging == false) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mru Mru Example App'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Tab>[
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
            controller: _tabController,
            children: <Widget>[
              SettingsTab(
                settingsTabCubit: settingsTabCubit,
                sendTabCubit: sendTabCubit,
                receiveTabCubit: receiveTabCubit,
              ),
              SendTab(sendTabCubit: sendTabCubit),
              ReceiveTab(receiveTabCubit: receiveTabCubit),
            ],
          ),
        ),
      ),
    );
  }
}
