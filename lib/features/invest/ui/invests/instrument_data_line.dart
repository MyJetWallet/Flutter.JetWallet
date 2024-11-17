import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class InstrumentDataLine extends StatelessObserverWidget {
  const InstrumentDataLine({
    super.key,
    required this.icon,
    required this.mainText,
    required this.secondaryText,
    this.secondaryColor,
  });

  final Widget icon;
  final String mainText;
  final String secondaryText;
  final Color? secondaryColor;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SizedBox(
      width: MediaQuery.of(context).size.width - 48,
      height: 18,
      child: Row(
        children: [
          icon,
          const SpaceW4(),
          Text(
            mainText,
            style: STStyles.body1InvestSM.copyWith(
              color: colors.black,
            ),
          ),
          const Spacer(),
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
