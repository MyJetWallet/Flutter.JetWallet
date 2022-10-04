import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class BottomTab extends StatelessWidget {
  const BottomTab({
    Key? key,
    this.text,
    this.icon,
    this.isTextBlue = false,
  }) : super(key: key);

  final String? text;
  final Widget? icon;

  final bool isTextBlue;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Container(
      margin: const EdgeInsets.only(
        right: 10,
        top: 1,
      ),
      padding: EdgeInsets.only(
        top: icon != null ? 5 : 3,
        bottom: icon != null ? 5 : 7,
        right: 15,
        left: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(24),
        ),
        border: Border.all(
          color: isTextBlue
              ? colors.blue.withOpacity(0.4)
              : colors.grey2.withOpacity(0.4),
        ),
      ),
      child: text != null
          ? Text(
              text ?? '',
              style: TextStyle(
                color: isTextBlue ? colors.blue : colors.black,
              ),
            )
          : icon,
    );
  }
}
