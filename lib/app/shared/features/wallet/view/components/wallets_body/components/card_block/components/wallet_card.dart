import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../screens/market/provider/market_items_pod.dart';
import '../../../../../../../../helpers/format_currency_amount.dart';
import '../../../../../../../../providers/base_currency_pod/base_currency_pod.dart';
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
    final baseCurrency = useProvider(baseCurrencyPod);
    final colors = useProvider(sColorPod);
    var buttonColor = colors.green;
    var cardColor = colors.greenLight;

    if (marketItem.dayPercentChange.isNegative) {
      buttonColor = colors.red;
      cardColor = colors.redLight;
    }

    return Container(
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
    );
  }
}
