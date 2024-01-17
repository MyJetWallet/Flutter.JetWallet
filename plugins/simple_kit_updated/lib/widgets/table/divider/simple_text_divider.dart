import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

class STextDivider extends StatelessWidget {
  const STextDivider(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 24, right: 24),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: STStyles.body2Semibold.copyWith(
                color: SColorsLight().gray8,
                height: 1.43,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
