import 'package:flutter/material.dart';

class ResendButton extends StatelessWidget {
  const ResendButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: const Text(
        'Resend',
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.grey,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
