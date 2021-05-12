import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../app_state.dart';
import 'account_actions.dart';

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
