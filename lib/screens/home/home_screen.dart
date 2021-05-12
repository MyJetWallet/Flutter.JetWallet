import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:injector/injector.dart';
import 'package:redux/redux.dart';

import '../../app_state.dart';
import '../../signal_r/signal_r_service.dart';
import 'account/account_screen.dart';
import 'wallet/wallet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final signalRService = Injector.appInstance.get<SignalRService>();
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const WalletScreen(),
    const AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      onInit: (store) {
        final token = store.state.userState.token;
        signalRService.init(token);
      },
      builder: (context, store) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Spot Wallet'),
          ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet),
                label: 'Wallet',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Account',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}
