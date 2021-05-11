import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:injector/injector.dart';
import 'package:jetwallet/api/spot_wallet_client.dart';
import 'package:jetwallet/app_state.dart';
import 'package:jetwallet/screens/login/login_animations.dart';
import 'package:jetwallet/screens/login/login_view_model.dart';
import 'package:jetwallet/screens/login/widgets/my_tick.dart';
import 'package:jetwallet/screens/login/widgets/sign_in_button.dart';
import 'package:jetwallet/screens/login/widgets/sign_up_link.dart';
import 'package:jetwallet/state/config/config_storage.dart';
import 'widgets/styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final client = Injector.appInstance.get<SpotWalletClient>();
  final configStorage = Injector.appInstance.get<ConfigStorage>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _loginButtonController;

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return StoreConnector<AppState, LoginViewModel>(
      converter: (store) => LoginViewModel.fromStore(store),
      onInit: (store) {
        _loginButtonController = AnimationController(
            duration: const Duration(milliseconds: 3000), vsync: this);
      },
      onDispose: (store) {
        _loginButtonController.dispose();
        _emailController.dispose();
        _passwordController.dispose();
      },
      builder: (context, vm) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: backgroundImage,
            ),
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: <Color>[
                  Color.fromRGBO(162, 146, 199, 0.8),
                  Color.fromRGBO(51, 51, 63, 0.9),
                ],
                stops: [0.2, 1.0],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(0, 1),
              )),
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          MyTick(image: tick),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Form(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              width: 0.5,
                                              color: Colors.white24,
                                            ),
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: _emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          decoration: const InputDecoration(
                                            icon: Icon(
                                              Icons.person_outline,
                                              color: Colors.white,
                                            ),
                                            border: InputBorder.none,
                                            hintText: 'Email',
                                            hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                            contentPadding: EdgeInsets.only(
                                                top: 30,
                                                right: 30,
                                                bottom: 30,
                                                left: 5),
                                          ),
                                          onChanged: (email) =>
                                              vm.setEmail(email),
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              width: 0.5,
                                              color: Colors.white24,
                                            ),
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: _passwordController,
                                          obscureText: vm.isPasswordVisible,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          decoration: InputDecoration(
                                            icon: const Icon(
                                              Icons.lock_outline,
                                              color: Colors.white,
                                            ),
                                            suffix: IconButton(
                                              onPressed: () =>
                                                  vm.setIsPasswordVisible(),
                                              icon: Icon(
                                                vm.isPasswordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                              ),
                                            ),
                                            border: InputBorder.none,
                                            hintText: 'Password',
                                            hintStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    top: 30,
                                                    right: 30,
                                                    bottom: 30,
                                                    left: 5),
                                          ),
                                          onChanged: (password) =>
                                              vm.setPassword(password),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SignUp(vm.onSignUpPress),
                          if (vm.appVersion.isNotEmpty)
                            Text(
                              'JetWallet ${vm.appVersion}:${vm.appBuildNumber}',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.5,
                                  color: Colors.grey,
                                  fontSize: 12),
                            )
                          else
                            Container(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: InkWell(
                          onTap: vm.isSignInEnabled
                              ? () {
                                  vm.onSignInPress(
                                    client,
                                    configStorage,
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                  _playAnimation();
                                }
                              : null,
                          child: SignIn(
                            isEnabled: vm.isSignInEnabled,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {
      //TODO(Vova): Error handling
    }
  }
}
