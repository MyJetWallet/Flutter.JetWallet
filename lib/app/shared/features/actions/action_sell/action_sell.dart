import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../helpers/format_currency_amount.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../currency_sell/view/currency_sell.dart';

void showSellAction(BuildContext context) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    maxHeight: 664.h,
    pinned: const SBottomSheetHeader(
      name: 'Choose asset to sell',
    ),
    children: [const _ActionSell()],
  );
}

class _ActionSell extends HookWidget {
  const _ActionSell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);

    return Column(
      children: [
        for (final currency in context.read(currenciesPod)) ...[
          if (currency.isAssetBalanceNotEmpty)
            SWalletItem(
              decline: currency.dayPercentChange.isNegative,
              icon: NetworkSvgW24(
                url: currency.iconUrl,
              ),
              name: currency.description,
              amount: formatCurrencyAmount(
                prefix: baseCurrency.prefix,
                value: currency.baseBalance,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
              ),
              balance: '${currency.assetBalance} ${currency.symbol}',
              onTap: () {
                navigatorPush(
                  context,
                  CurrencySell(
                    currency: currency,
                  ),
                );
              },
            ),
        ]
      ],
    );
  }
}
