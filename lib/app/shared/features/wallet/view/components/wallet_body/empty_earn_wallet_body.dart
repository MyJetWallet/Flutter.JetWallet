import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../../screens/portfolio/helper/max_currency_apy.dart';
import '../../../../../providers/currencies_pod/currencies_pod.dart';
import 'components/empty_wallet_balance_text.dart';

class EmptyEarnWalletBody extends HookWidget {
  const EmptyEarnWalletBody({
    Key? key,
    required this.assetName,
  }) : super(key: key);

  final String assetName;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final deviceSize = useProvider(deviceSizePod);
    final currencies = useProvider(currenciesPod);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: colors.green,
              ),
              child: Text(
                '${maxCurrencyApy(currencies).toStringAsFixed(0)}% APY',
                style: sSubtitle3Style.copyWith(color: colors.white),
              ),
            ),
          ],
        ),
        deviceSize.when(
          small: () {
            return EmptyWalletBalanceText(
              height: 128,
              baseline: 115,
              color: colors.grey2,
            );
          },
          medium: () {
            return EmptyWalletBalanceText(
              height: 184,
              baseline: 171,
              color: colors.grey2,
            );
          },
        ),
        const Spacer(),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Earn ',
                style: sTextH3Style.copyWith(
                  color: colors.black,
                ),
              ),
              TextSpan(
                text: '${maxCurrencyApy(currencies).toStringAsFixed(0)}%'
                    ' interest',
                style: sTextH3Style.copyWith(
                  color: colors.green,
                ),
              ),
              const WidgetSpan(
                child: SpaceW10(),
              ),
              const WidgetSpan(
                child: SInfoIcon(),
              ),
            ],
          ),
        ),
        const SpaceH13(),
        Text(
          'Invest in Bitcoin and start earning daily',
          textAlign: TextAlign.center,
          maxLines: 2,
          style: sBodyText1Style.copyWith(
            color: colors.grey1,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
