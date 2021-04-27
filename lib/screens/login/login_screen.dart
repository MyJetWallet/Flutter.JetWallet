import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:jetwallet/screens/login/login_animations.dart';
import 'package:jetwallet/widgets/form_container.dart';
import 'package:jetwallet/widgets/my_tick.dart';
import 'package:jetwallet/widgets/sign_in_button.dart';
import 'package:jetwallet/widgets/sign_up_link.dart';

import 'styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _loginButtonController;
  var animationStatus = 0;

  @override
  void initState() {
    super.initState();
    _loginButtonController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {
      //TODO(Vova): Error handling
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ) as Future<bool>;
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
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
                              const FormContainer(),
                              const SignUp()
                            ],
                          ),
                          if (animationStatus == 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      animationStatus = 1;
                                    });
                                    _playAnimation();
                                  },
                                  child: const SignIn()),
                            )
                          else
                            StaggerAnimation(
                                buttonController: _loginButtonController),
                        ],
                      ),
                    ],
                  ))),
        ));
  }
}
