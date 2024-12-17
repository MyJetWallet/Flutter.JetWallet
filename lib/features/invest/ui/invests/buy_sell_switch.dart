import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

import '../../../../core/l10n/i10n.dart';

class BuySellSwitch extends StatelessObserverWidget {
  const BuySellSwitch({
    super.key,
    required this.onChangeTab,
    required this.isBuy,
  });

  final Function(bool) onChangeTab;
  final bool isBuy;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    void changeActiveTab(bool newValue) {
      onChangeTab(newValue);
    }

    return Row(
      children: [
        GestureDetector(
          onTap: () => changeActiveTab(true),
          child: Container(
            width: 70,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              color: isBuy ? colors.green : colors.gray2,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.svg.invest.buy.simpleSvg(
                    width: 16,
                    height: 16,
                    color: isBuy ? colors.white : colors.gray10,
                  ),
                  const SpaceW4(),
                  Text(
                    intl.invest_buy,
                    style: STStyles.body1InvestSM.copyWith(
                      color: isBuy ? colors.white : colors.gray10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => changeActiveTab(false),
          child: Container(
            width: 70,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              color: isBuy ? colors.gray2 : colors.red,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.svg.invest.sell.simpleSvg(
                    width: 16,
                    height: 16,
                    color: isBuy ? colors.gray10 : colors.white,
                  ),
                  const SpaceW4(),
                  Text(
                    intl.invest_sell,
                    style: STStyles.body1InvestSM.copyWith(
                      color: isBuy ? colors.gray10 : colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
