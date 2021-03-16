import 'package:flutter/material.dart';
import 'package:jetwallet/global/theme.dart';
import 'package:jetwallet/spot_home/signalr/signalrcore.dart';
import 'package:jetwallet/spot_home/widgets/kchart.dart';

class _SpotScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("SPOT APPLICATION"))),
      body: Column(
        children: [
          TextButton(
              child: Center(child: Text("SHOW ME THE CHART")),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => KChart()))),
          TextButton(
              child: Center(child: Text("SHOW ME SignalR_Core")),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SpotSignalRCore()))),
        ],
      ),
    );
  }
}

class SpotHome extends StatefulWidget {
  // Root
  @override
  _SpotHomeState createState() => _SpotHomeState();
}

class _SpotHomeState extends State<SpotHome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JetWallet',
      theme: globalSpotTheme,
      home: _SpotScaffold(),
    );
  }
}
