import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../helpers/format_currency_amount.dart';
import '../../../../../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../../../../../market_details/helper/currency_from.dart';

class WalletCardCollapsed extends HookWidget {
  const WalletCardCollapsed({
    Key? key,
    required this.assetId,
  }) : super(key: key);

  final String assetId;

  @override
  Widget build(BuildContext context) {
    final currency = currencyFrom(
      useProvider(currenciesPod),
      assetId,
    );
    final baseCurrency = useProvider(baseCurrencyPod);
    final colors = useProvider(sColorPod);

    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const SpaceH120(),
          SBaselineChild(
            baseline: 40,
            child: Text(
              formatCurrencyAmount(
                prefix: baseCurrency.prefix,
                value: currency.baseBalance,
                accuracy: baseCurrency.accuracy,
                symbol: baseCurrency.symbol,
              ),
              style: sTextH5Style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SBaselineChild(
            baseline: 20,
            child: Text(
              formatCurrencyAmount(
                symbol: currency.assetId,
                value: currency.assetBalance,
                accuracy: currency.accuracy,
                prefix: currency.prefixSymbol,
              ),
              style: sBodyText2Style.copyWith(
                color: colors.grey1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
