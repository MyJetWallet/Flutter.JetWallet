import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

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

    final colors = sKit.colors;

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
              color: isBuy ? colors.green : colors.grey5,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SIBuyIcon(
                    width: 16,
                    height: 16,
                    color: isBuy ? colors.white : colors.grey1,
                  ),
                  const SpaceW4(),
                  Text(
                    intl.invest_buy,
                    style: sBody1InvestSMStyle.copyWith(
                      color: isBuy ? colors.white : colors.grey1,
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
              color: isBuy ? colors.grey5 : colors.red,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SISellIcon(
                    width: 16,
                    height: 16,
                    color: isBuy ? colors.grey1 : colors.white,
                  ),
                  const SpaceW4(),
                  Text(
                    intl.invest_sell,
                    style: sBody1InvestSMStyle.copyWith(
                      color: isBuy ? colors.grey1 : colors.white,
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
