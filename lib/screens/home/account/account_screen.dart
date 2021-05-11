import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jetwallet/app_state.dart';
import 'package:jetwallet/screens/home/account/account_actions.dart';
import 'package:redux/redux.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        return Center(
          child: TextButton(
            onPressed: () => store.dispatch(logOut()),
            child: const Text('Logout'),
          ),
        );
      },
    );
  }
}
