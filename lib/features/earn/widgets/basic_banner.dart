import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

class SBasicBanner extends StatelessWidget {
  const SBasicBanner({
    required this.text,
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return ColoredBox(
      color: colors.yellowLight,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SInfoIcon(),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: STStyles.body2Medium.copyWith(
                  color: colors.black,
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
