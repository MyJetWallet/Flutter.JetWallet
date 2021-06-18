import 'package:flutter/material.dart';

class SpotButton extends StatelessWidget {
  const SpotButton({
    Key? key,
    required this.text,
    required this.onTap,
    required this.textColor,
    required this.decoration,
  }) : super(key: key);

  final String text;
  final void Function() onTap;
  final Color textColor;
  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
        ),
        width: double.infinity,
        decoration: decoration,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
