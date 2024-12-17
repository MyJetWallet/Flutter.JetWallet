import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

class RolloverLine extends StatelessObserverWidget {
  const RolloverLine({
    super.key,
    required this.mainText,
    required this.secondaryText,
  });

  final String mainText;
  final String secondaryText;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return SizedBox(
      width: MediaQuery.of(context).size.width - 48,
      child: Row(
        children: [
          Text(
            mainText,
            style: STStyles.body1InvestM.copyWith(
              color: colors.gray8,
            ),
          ),
          const SpaceW5(),
          Text(
            secondaryText,
            style: STStyles.body3InvestSM.copyWith(
              color: colors.gray8,
            ),
          ),
          const SpaceW5(),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                color: colors.gray4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
