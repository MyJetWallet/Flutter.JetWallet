import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class ClickableUnderlinedText extends StatelessWidget {
  const ClickableUnderlinedText({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          style: sBodyText2Style,
        ),
      ),
    );
  }
}
