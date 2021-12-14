import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class CardPart extends StatelessWidget {
  const CardPart({
    Key? key,
    this.width = 62,
    required this.left,
  }) : super(key: key);

  final bool left;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: width,
      decoration: BoxDecoration(
        color: SColorsLight().greenLight,
        borderRadius: left
            ? const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
      ),
      child: const SizedBox(),
    );
  }
}
