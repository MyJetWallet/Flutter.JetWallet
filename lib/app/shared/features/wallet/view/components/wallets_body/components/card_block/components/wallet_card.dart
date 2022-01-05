import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../screens/market/helper/format_day_percentage_change.dart';
import '../../../../../../../../../screens/market/provider/market_items_pod.dart';
import '../../../../../../../../helpers/format_currency_amount.dart';
import '../../../../../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../../../../../market_details/helper/currency_from.dart';
import '../../../../../../helper/market_item_from.dart';

class WalletCard extends HookWidget {
  const WalletCard({
    Key? key,
    required this.assetId,
    required this.currentPage,
  }) : super(key: key);

  final String assetId;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final marketItem = marketItemFrom(
      useProvider(marketItemsPod),
      assetId,
    );
    final currency = currencyFrom(
      useProvider(currenciesPod),
      assetId,
    );
    final baseCurrency = useProvider(baseCurrencyPod);
    final colors = useProvider(sColorPod);
    var buttonColor = colors.green;
    var cardColor = colors.greenLight;

    if (marketItem.dayPercentChange.isNegative) {
      buttonColor = colors.red;
      cardColor = colors.redLight;
    }

    return InkWell(
      onTap: () {
        sShowBasicModalBottomSheet(
          context: context,
          removeBarPadding: true,
          horizontalPadding: 24,
          children: [
            const SpaceH11(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formatCurrencyAmount(
                    prefix: baseCurrency.prefix,
                    value: marketItem.baseBalance,
                    accuracy: baseCurrency.accuracy,
                    symbol: baseCurrency.symbol,
                  ),
                  style: sSubtitle3Style,
                ),
                Text(
                  ' (${formatDayPercentageChange(marketItem.dayPercentChange)}'
                  ')',
                  style: sSubtitle3Style.copyWith(color: buttonColor),
                ),
              ],
            ),
            const SpaceH53(),
            Center(
              child: Text(
                marketItem.name,
                style: sSubtitle2Style,
              ),
            ),
            const SpaceH2(),
            Center(
              child: Text(
                formatCurrencyAmount(
                  prefix: baseCurrency.prefix,
                  value: marketItem.baseBalance,
                  accuracy: baseCurrency.accuracy,
                  symbol: baseCurrency.symbol,
                ),
                style: sTextH1Style,
              ),
            ),
            Center(
              child: Text(
                formatCurrencyAmount(
                  symbol: marketItem.id,
                  value: marketItem.assetBalance,
                  accuracy: marketItem.accuracy,
                  prefix: marketItem.prefixSymbol,
                ),
                style: sBodyText2Style.copyWith(
                  color: colors.grey1,
                ),
              ),
            ),
            const SpaceH82(),
            Row(
              children: [
                Text(
                  'Accumulated interest earned',
                  style: sBodyText2Style,
                ),
                const SpaceW10(),
                STransparentInkWell(
                  onTap: () {
                    // TODO(Vova): Open webview on tap
                  },
                  child: const SInfoIcon(),
                ),
                const Spacer(),
                Text(
                  formatCurrencyAmount(
                    prefix: baseCurrency.prefix,
                    value: currency.totalEarnAmount,
                    accuracy: baseCurrency.accuracy,
                    symbol: baseCurrency.symbol,
                  ),
                  style: sBodyText1Style.copyWith(
                    color: colors.green,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Next pay',
                  style: sBodyText2Style.copyWith(
                    color: colors.grey1,
                  ),
                ),
                const Spacer(),
                Text(
                  '${DateFormat('d MMM').format(
                    DateTime.parse(currency.nextPaymentDate).toLocal(),
                  )} (\$12.10)',
                  style: sBodyText1Style,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'APY',
                  style: sBodyText2Style.copyWith(
                    color: colors.grey1,
                  ),
                ),
                const Spacer(),
                Text(
                  '${currency.apy.toInt()}%',
                  style: sBodyText1Style,
                ),
              ],
            ),
          ],
        );
      },
      child: Container(
        height: 280,
        width: 280,
        margin: EdgeInsets.symmetric(
          horizontal: currentPage >= 1 ? 10 : 24,
        ),
        padding: const EdgeInsets.only(
          top: 40,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            SNetworkSvg24(
              url: marketItem.iconUrl,
            ),
            const SpaceH14(),
            Text(
              marketItem.name,
              style: sSubtitle2Style,
            ),
            const SpaceH2(),
            Text(
              formatCurrencyAmount(
                prefix: baseCurrency.prefix,
                value: marketItem.baseBalance,
                accuracy: baseCurrency.accuracy,
                symbol: baseCurrency.symbol,
              ),
              style: sTextH1Style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              formatCurrencyAmount(
                symbol: marketItem.id,
                value: marketItem.assetBalance,
                accuracy: marketItem.accuracy,
                prefix: marketItem.prefixSymbol,
              ),
              style: sBodyText2Style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 24,
                  width: 83,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: buttonColor,
                  ),
                  child: Baseline(
                    baseline: 17,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      '+\$120.23',
                      style: sSubtitle3Style.copyWith(color: colors.white),
                    ),
                  ),
                ),
                const SInfoIcon(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
