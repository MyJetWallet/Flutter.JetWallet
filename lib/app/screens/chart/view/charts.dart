import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Charts extends HookWidget {
  const Charts();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: [
              Tab(text: 'BTCUSD'),
              Tab(text: 'ETHUSD'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [],
        ),
      ),
    );
  }
}
