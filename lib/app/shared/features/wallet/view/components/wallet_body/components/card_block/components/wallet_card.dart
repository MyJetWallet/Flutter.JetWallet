import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../helpers/format_currency_amount.dart';
import '../../../../../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../../../../../market_details/helper/currency_from.dart';

class WalletCard extends HookWidget {
  const WalletCard({
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
      height: 150,
      width: double.infinity,
      margin: const EdgeInsets.only(
        top: 120,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 32,
            ),
            child: SNetworkSvg24(
              url: currency.iconUrl,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 34,
            ),
            child: SBaselineChild(
              baseline: 50,
              child: Text(
                currency.description,
                style: sSubtitle2Style,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 24,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              margin: const EdgeInsets.only(top: 32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colors.green,
              ),
              child: SBaselineChild(
                baseline: 17,
                child: Text(
                  '+\$120.23',
                  style: sSubtitle3Style.copyWith(color: colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 50,
            ),
            child: SBaselineChild(
              baseline: 48,
              child: Text(
                formatCurrencyAmount(
                  prefix: baseCurrency.prefix,
                  value: currency.baseBalance,
                  accuracy: baseCurrency.accuracy,
                  symbol: baseCurrency.symbol,
                ),
                style: sTextH1Style,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 98,
            ),
            child: SBaselineChild(
              baseline: 24,
              child: Text(
                formatCurrencyAmount(
                  symbol: currency.assetId,
                  value: currency.assetBalance,
                  accuracy: currency.accuracy,
                  prefix: currency.prefixSymbol,
                ),
                style: sBodyText2Style.copyWith(color: colors.grey1),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              bottom: 20,
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: SInfoIcon(),
            ),
          )
        ],
      ),
    );
  }
}
