import 'package:flutter/material.dart';
import 'package:jetwallet/api/model/common_response.dart';

class SignUp extends StatelessWidget {
  const SignUp(this.onPressed, {Key? key}) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 160,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: const Text(
          "Don't have an account? Sign Up",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: TextStyle(
              fontWeight: FontWeight.w300,
              letterSpacing: 0.5,
              color: Colors.white,
              fontSize: 12),
        ),
      ),
    );
  }
}
