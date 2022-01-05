import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
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
    required this.walletBackground,
  }) : super(key: key);

  final String assetId;
  final String walletBackground;

  @override
  Widget build(BuildContext context) {
    final currency = currencyFrom(
      useProvider(currenciesPod),
      assetId,
    );
    final baseCurrency = useProvider(baseCurrencyPod);
    final colors = useProvider(sColorPod);

    return Stack(
      children: [
        SvgPicture.asset(
          walletBackground,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
        SizedBox(
          height: 270,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SPaddingH24(
                child: SSmallHeader(
                  title: '${currency.description} wallet',
                ),
              ),
              const Spacer(),
              SPaddingH24(
                child: Row(
                  children: [
                    SNetworkSvg24(
                      url: currency.iconUrl,
                    ),
                    const SpaceW10(),
                    Text(
                      currency.description,
                      style: sSubtitle2Style,
                    ),
                    const Spacer(),
                    Container(
                      height: 24,
                      width: 83,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: colors.green,
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
                  ],
                ),
              ),
              const SpaceH8(),
              SPaddingH24(
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
              SPaddingH24(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
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
                    const SInfoIcon(),
                  ],
                ),
              ),
              const Spacer(),
              // const SpaceH20(),
            ],
          ),
        )
      ],
    );
  }
}
