import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class FooterCell extends StatelessWidget {
  const FooterCell({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SColorsLight().white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: STStyles.captionMedium.copyWith(
              color: SColorsLight().gray10,
            ),
          ),
        ),
      ),
    );
  }
}
