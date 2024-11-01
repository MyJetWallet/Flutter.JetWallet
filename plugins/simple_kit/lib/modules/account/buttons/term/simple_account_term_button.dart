import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';

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
        child: STransparentInkWell(
          onTap: onTap,
          child: Text(
            name,
            style: sBodyText2Style.copyWith(
              shadows: [
                const Shadow(color: Colors.black, offset: Offset(0, -5)),
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
