import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

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

    final colors = sKit.colors;

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
            style: sBody2InvestMStyle.copyWith(
              color: colors.grey1,
            ),
          ),
          if (fullWidth)
            const Spacer()
          else
            const SpaceW5(),
          Text(
            secondaryText,
            style: sBody1InvestSMStyle.copyWith(
              color: secondaryColor ?? colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
