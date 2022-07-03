import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth.dart';
import 'view.dart';

class DashView extends ConsumerStatefulWidget {
  DashView({
    required String selectedTab,
    Key? key,
  })  : index = dashBoardTabs.indexWhere((tab) => tab == selectedTab),
        super(key: key) {
    assert(index != -1);
  }

  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<DashView>
    with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: dashBoardTabs.length,
      vsync: this,
      initialIndex: widget.index,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DashView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.index = widget.index;
  }

  List<Widget> _buildScreens() {
    return [
      const HomeView(),
      const HomeView(),
      const HomeView(),
    ];
  }

  List<Widget> _buildTabs() {
    return [
      NavigationDestination(
        selectedIcon: const Icon(Icons.home),
        icon: const Icon(Icons.home_outlined),
        label: dashBoardTabs[0].toUpperCase(),
      ),
      NavigationDestination(
        selectedIcon: const Icon(Icons.event_rounded),
        icon: const Icon(Icons.event_outlined),
        label: dashBoardTabs[1].toUpperCase(),
      ),
      NavigationDestination(
        selectedIcon: const Icon(Icons.person),
        icon: const Icon(Icons.person_outline),
        label: dashBoardTabs[2].toUpperCase(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dashBoardTabs[widget.index]),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () {
              ref.watch(userProvider.notifier).logout();
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _controller.index,
        onDestinationSelected: (index) =>
            context.go('/dash/${dashBoardTabs[index]}'),
        destinations: _buildTabs(),
      ),
      body: TabBarView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: _buildScreens(),
      ),
    );
  }
}

List<String> dashBoardTabs = [
  'home',
  'inbox',
  'profile',
];
