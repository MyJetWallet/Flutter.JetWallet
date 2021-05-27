import 'package:flutter/material.dart';

class ConvertButton extends StatelessWidget {
  const ConvertButton({
    Key? key,
    required this.name,
    required this.onPressed,
  }) : super(key: key);

  final String name;
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
      child:  Text(
        name,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
