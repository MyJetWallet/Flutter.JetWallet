import 'package:flutter/material.dart';
import 'package:jetwallet/global/theme.dart';
import 'package:jetwallet/spot_home/widgets/kchart.dart';

class SpotHome extends StatelessWidget {
  // Root
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JetWallet',
      theme: globalSpotTheme,
      home: Scaffold(
        appBar: AppBar(title: Center(child: Text("SPOT APPLICATION"))),
        body: KChart(),
      ),
    );
  }
}
