import 'package:flutter/material.dart';
import 'components/chart_view.dart';

class Chart extends StatelessWidget {
  const Chart();

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
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ChartView(
              'BTCUSD',
              (_) {},
            ),
            ChartView(
              'ETHUSD',
              (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
