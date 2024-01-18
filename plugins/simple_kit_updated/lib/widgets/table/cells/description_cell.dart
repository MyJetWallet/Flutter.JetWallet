import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

import '../../../simple_kit_updated.dart';

class DescriptionCell extends StatelessWidget {
  const DescriptionCell({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SColorsLight().white,
      child: SizedBox(
        height: 32,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8,
          ),
          child: Text(
            text,
            style: STStyles.captionMedium.copyWith(
              color: SColorsLight().gray8,
            ),
          ),
        ),
      ),
    );
  }
}
