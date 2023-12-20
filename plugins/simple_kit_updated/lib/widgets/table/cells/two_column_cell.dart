import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

class TwoColumnCell extends StatelessWidget {
  const TwoColumnCell({
    Key? key,
    required this.label,
    this.value,
    this.needHorizontalPadding = true,
  }) : super(key: key);

  final String label;
  final String? value;

  final bool needHorizontalPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: needHorizontalPadding ? 24 : 0, vertical: 8),
        child: Row(
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: STStyles.body2Medium.copyWith(color: SColorsLight().gray10),
                ),
                const Gap(8),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                if (value != null)
                  Text(
                    value ?? '',
                    textAlign: TextAlign.right,
                    style: STStyles.subtitle2,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
