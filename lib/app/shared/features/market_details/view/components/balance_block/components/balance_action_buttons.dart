import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../screens/market/model/market_item_model.dart';
import '../../../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../../../currency_buy/view/curency_buy.dart';
import '../../../../../currency_sell/view/currency_sell.dart';
import '../../../../helper/currency_from.dart';

class BalanceActionButtons extends HookWidget {
  const BalanceActionButtons({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final currency = currencyFrom(
      useProvider(currenciesPod),
      marketItem.associateAsset,
    );

    return SPaddingH24(
      child: Row(
        children: [
          Expanded(
            child: SPrimaryButton1(
              name: _buyButtonText(),
              onTap: () {
                navigatorPush(
                  context,
                  CurrencyBuy(
                    currency: currency,
                  ),
                );
              },
              active: true,
            ),
          ),
          if (!marketItem.isBalanceEmpty) ...[
            const SpaceW11(),
            Expanded(
              child: SSecondaryButton1(
                name: 'Sell',
                onTap: () {
                  navigatorPush(
                    context,
                    CurrencySell(
                      currency: currency,
                    ),
                  );
                },
                active: true,
              ),
            ),
          ]
        ],
      ),
    );
  }

  String _buyButtonText() {
    if (marketItem.isBalanceEmpty) {
      return 'Buy ${marketItem.name}';
    } else {
      return 'Buy';
    }
  }
}
