import 'package:flutter/material.dart';

import 'auth_button.dart';

class AuthButtonPink extends StatelessWidget {
  const AuthButtonPink({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return AuthButton(
      text: text,
      onTap: onTap,
      decoration: BoxDecoration(
        color: Colors.pink[400],
        borderRadius: BorderRadius.circular(8),
      ),
      textColor: Colors.white,
    );
  }
}
