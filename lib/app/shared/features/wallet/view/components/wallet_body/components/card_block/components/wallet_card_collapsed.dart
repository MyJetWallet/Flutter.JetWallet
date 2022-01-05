import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
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

    Stack(
      children: [
        SvgPicture.asset(
          walletBackground,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
        SPaddingH24(
          child: SSmallHeader(
            title: '${currency.description} wallet',
          ),
        ),
      ],
    );

    return Stack(
      children: [
        SvgPicture.asset(
          walletBackground,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
        SizedBox(
          height: 204,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SPaddingH24(
                child: SSmallHeader(
                  title: '${currency.description} wallet',
                ),
              ),
              const Spacer(),
              Text(
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
              const SpaceH14(),
            ],
          ),
        )
      ],
    );
  }
}
