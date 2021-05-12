import 'package:flutter/material.dart';

import '../../../shared/theme/styles.dart';

class AuthFrame extends StatelessWidget {
  const AuthFrame({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
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
            ),
          ),
          child: SafeArea(
            child: Container(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
