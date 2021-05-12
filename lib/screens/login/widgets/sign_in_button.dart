import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  const SignIn({
    required this.isEnabled,
    Key? key,
    this.activeColor = const Color.fromRGBO(247, 64, 106, 1),
    this.text = 'Sign In',
  }) : super(key: key);

  final String text;
  final bool isEnabled;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    final color = isEnabled ? activeColor : Colors.grey;
    return Container(
      width: 320,
      height: 60,
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        // color: Color.fromRGBO(247, 64, 106, 1),
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
