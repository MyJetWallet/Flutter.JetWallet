import 'package:flutter/material.dart';
import 'package:jetwallet/spot_home/signalr/walletapi_screen.dart';

class _SpotScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Wallet Technical PoC'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(
                onPressed: () => Navigator.push<MaterialPageRoute>(context,
                    MaterialPageRoute(builder: (context) => WalletAPIScreen())),
                child: const Center(
                    child: Text('Show me Wallet API Integration'))),
          ),
        ],
      ),
    );
  }
}

class SpotHome extends StatefulWidget {
  const SpotHome({Key? key}) : super(key: key);

  @override
  _SpotHomeState createState() => _SpotHomeState();
}

class _SpotHomeState extends State<SpotHome> {
  @override
  Widget build(BuildContext context) {
    return _SpotScaffold();
  }
}
