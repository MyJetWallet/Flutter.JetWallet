import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../shared/components/buttons/app_buton_white.dart';
import '../../../../../../../shared/components/spacers.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/features/currency_buy/view/curency_buy.dart';
import '../../../../../../shared/features/currency_sell/view/currency_sell.dart';
import '../../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../../../../../market/model/market_item_model.dart';
import '../../../../helper/currency_from.dart';

class BalanceActionButtons extends HookWidget {
  const BalanceActionButtons({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final currencies = useProvider(currenciesPod);
    final currency = currencyFrom(
      currencies,
      marketItem.associateAsset,
    );

    return Row(
      children: [
        Expanded(
          child: AppButtonWhite(
            name: 'Buy',
            onTap: () {
              navigatorPush(
                context,
                CurrencyBuy(
                  currency: currency,
                ),
              );
            },
          ),
        ),
        if (!marketItem.isBalanceEmpty) ...[
          const SpaceW16(),
          Expanded(
            child: AppButtonWhite(
              name: 'Sell',
              onTap: () {
                navigatorPush(
                  context,
                  CurrencySell(
                    currency: currency,
                  ),
                );
              },
            ),
          ),
        ]
      ],
    );
  }
}
