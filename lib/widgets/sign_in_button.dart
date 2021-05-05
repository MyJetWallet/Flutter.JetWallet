import 'package:flutter/material.dart';
import 'package:jetwallet/screens/login/login_screen.dart';

class SignIn extends StatelessWidget {
  SignIn({Key? key, required this.isSignInEnabled}) : super(key: key);

  bool isSignInEnabled;

  @override
  Widget build(BuildContext context) {
    final color = isSignInEnabled ? Color.fromRGBO(247, 64, 106, 1) : Colors.grey;
    return Container(
      width: 320,
      height: 60,
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        // color: Color.fromRGBO(247, 64, 106, 1),
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: const Text(
        'Sign In',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
