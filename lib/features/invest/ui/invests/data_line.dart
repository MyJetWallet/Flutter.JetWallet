import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

class DataLine extends StatelessObserverWidget {
  const DataLine({
    super.key,
    required this.mainText,
    required this.secondaryText,
    this.secondaryColor,
    this.withDot = false,
    this.fullWidth = true,
    this.dotColor,
  });

  final String mainText;
  final String secondaryText;
  final bool withDot;
  final bool fullWidth;
  final Color? secondaryColor;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return SizedBox(
      width: fullWidth ? MediaQuery.of(context).size.width - 48 : null,
      height: 18,
      child: Row(
        children: [
          if (withDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: dotColor ?? colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SpaceW8(),
          ],
          Text(
            mainText,
            style: STStyles.body2InvestM.copyWith(
              color: colors.gray10,
            ),
          ),
          if (fullWidth) const Spacer() else const SpaceW5(),
          Text(
            secondaryText,
            style: STStyles.body1InvestSM.copyWith(
              color: secondaryColor ?? colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
