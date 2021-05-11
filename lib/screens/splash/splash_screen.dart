import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:injector/injector.dart';
import 'package:jetwallet/api/spot_wallet_client.dart';
import 'package:jetwallet/app_state.dart';
import 'package:jetwallet/screens/loader/loader_actions.dart';
import 'package:jetwallet/screens/login/widgets/styles.dart';
import 'package:jetwallet/screens/splash/splash_actions.dart';
import 'package:jetwallet/state/config/config_storage.dart';
import 'package:redux/redux.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final _client = Injector.appInstance.get<SpotWalletClient>();
  final _configStorage = Injector.appInstance.get<ConfigStorage>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      onInit: (store) {
        store.dispatch(SetIsLoading(true));
        Timer(
          const Duration(seconds: 2),
          () => store.dispatch(refreshToken(_client, _configStorage)),
        );
      },
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            image: backgroundImage,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color.fromRGBO(162, 146, 199, 0.8),
                  Color.fromRGBO(51, 51, 63, 0.9),
                ],
                stops: [0.2, 1.0],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(0, 1),
              ),
            ),
            child: Container(),
          ),
        );
      },
    );
  }
}
