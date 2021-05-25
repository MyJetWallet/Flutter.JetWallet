import 'package:flutter/material.dart';

class RequestQuoteButton extends StatelessWidget {
  const RequestQuoteButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color(0xFFF5F5F5),
        ),
      ),
      child: const Text(
        'Request Quote',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
