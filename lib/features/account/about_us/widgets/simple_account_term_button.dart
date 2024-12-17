import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

class SimpleAccountTermButton extends StatelessWidget {
  const SimpleAccountTermButton({
    super.key,
    required this.name,
    required this.onTap,
  });

  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(bottom: 1.0),
        child: SafeGesture(
          onTap: onTap,
          child: Text(
            name,
            style: STStyles.body2Medium.copyWith(
              shadows: [
                const Shadow(offset: Offset(0, -5)),
              ],
              color: Colors.transparent,
              decoration: TextDecoration.underline,
              decorationColor: Colors.black,
              decorationThickness: 3,
            ),
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}
