import 'package:flutter/material.dart';
import 'components/chart_view.dart';

class Charts extends StatelessWidget {
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
          physics: NeverScrollableScrollPhysics(),
          children: [
            ChartView('BTCUSD'),
            ChartView('ETHUSD'),
          ],
        ),
      ),
    );
  }
}
