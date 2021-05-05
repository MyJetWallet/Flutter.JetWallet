import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jetwallet/app_state.dart';
import 'package:jetwallet/screens/login/login_animations.dart';
import 'package:jetwallet/widgets/my_tick.dart';
import 'package:jetwallet/widgets/sign_in_button.dart';
import 'package:jetwallet/widgets/sign_up_link.dart';
import 'package:redux/redux.dart';
import 'styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _loginButtonController;
  bool isSignInEnabled = false;
  var animationStatus = 0;

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      onInit: (store) {
        _loginButtonController = AnimationController(
            duration: const Duration(milliseconds: 3000), vsync: this);
      },
      onDispose: (store) {
        _loginButtonController.dispose();
      },
      builder: (context, store) {
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                              onChanged: (text) {
                                                if (text.isEmpty) {
                                                  isSignInEnabled = false;
                                                } else {
                                                  isSignInEnabled = true;
                                                }
                                                setState(() {});
                                              },
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                              decoration: const InputDecoration(
                                                icon: Icon(
                                                  Icons.person_outline,
                                                  color: Colors.white,
                                                ),
                                                border: InputBorder.none,
                                                hintText: 'Username',
                                                hintStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                                contentPadding: EdgeInsets.only(
                                                    top: 30,
                                                    right: 30,
                                                    bottom: 30,
                                                    left: 5),
                                              ),
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
                                              obscureText: true,
                                              onChanged: (text) {
                                                if (text.isEmpty) {
                                                  isSignInEnabled = false;
                                                } else {
                                                  isSignInEnabled = true;
                                                }
                                                setState(() {});
                                              },
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                              decoration: const InputDecoration(
                                                icon: Icon(
                                                  Icons.lock_outline,
                                                  color: Colors.white,
                                                ),
                                                border: InputBorder.none,
                                                hintText: 'Password',
                                                hintStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                                contentPadding: EdgeInsets.only(
                                                    top: 30,
                                                    right: 30,
                                                    bottom: 30,
                                                    left: 5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SignUp(),
                              if (store
                                  .state.appConfigState.appVersion.isNotEmpty)
                                Text(
                                  'JetWallet ${store.state.appConfigState.appVersion}:${store.state.appConfigState.appBuildNumber}',
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
                          if (animationStatus == 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: InkWell(
                                  onTap: isSignInEnabled
                                      ? () {
                                          setState(() {
                                            animationStatus = 1;
                                          });
                                          _playAnimation();
                                        }
                                      : null,
                                  child: SignIn(
                                    isSignInEnabled: isSignInEnabled,
                                  )),
                            )
                          else
                            StaggerAnimation(
                                buttonController: _loginButtonController),
                        ],
                      ),
                    ],
                  ))),
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
