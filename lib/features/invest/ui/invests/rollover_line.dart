import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

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

    final colors = sKit.colors;

    return SizedBox(
      width: MediaQuery.of(context).size.width - 48,
      child: Row(
        children: [
          Text(
            mainText,
            style: sBody3InvestMStyle.copyWith(
              color: colors.grey2,
            ),
          ),
          const SpaceW5(),
          Text(
            secondaryText,
            style: sBody3InvestSMStyle.copyWith(
              color: colors.grey2,
            ),
          ),
          const SpaceW5(),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                color: colors.grey4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
