import 'package:flutter/material.dart';
import 'package:jetwallet/global/theme.dart';
import 'package:jetwallet/spot_home/signalr/walletapi_screen.dart';
import 'package:jetwallet/spot_home/widgets/kchart.dart';

class _SpotScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("SPOT Technical PoC"))),
      body: Column(
        children: [
          /*Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                child: Center(child: Text("Show me the Chart")),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => KChartScreen()))),
          ),*/
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                child: Center(child: Text("Show me Wallet API Integration")),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WalletAPIScreen()))),
          ),
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
