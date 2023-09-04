import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class BottomTab extends StatelessWidget {
  const BottomTab({
    super.key,
    this.text,
    this.icon,
    //this.isActive = false,
    this.isTextBlue = false,
  });

  final String? text;
  final Widget? icon;

  //final bool isActive;
  final bool isTextBlue;

  @override
  Widget build(BuildContext context) {
    final scolors = sKit.colors;

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
              ? scolors.blue.withOpacity(0.4)
              : scolors.grey2.withOpacity(0.4),
          /*color: isTextBlue
              ? isActive
                  ? Colors.transparent
                  : scolors.blue.withOpacity(0.4)
              : scolors.grey2.withOpacity(0.4),
              */
        ),
        /*
        color: isTextBlue
            ? isActive
                ? scolors.blue
                : Colors.transparent
            : Colors.transparent,
            */
      ),
      child: text != null
          ? Text(
              text ?? '',
              style: TextStyle(
                color: isTextBlue ? scolors.blue : scolors.black,
                /*color: isTextBlue
                    ? isActive
                        ? scolors.white
                        : scolors.blue
                    : scolors.black,
                    */
              ),
            )
          : icon,
    );
  }
}
