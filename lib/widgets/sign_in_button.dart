import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 60,
      alignment: FractionalOffset.center,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(247, 64, 106, 1),
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
