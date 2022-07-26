import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/constants.dart';
import '../../../../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../../shared/features/actions/action_buy/action_buy.dart';
import '../../../../../../../shared/helpers/formatting/formatting.dart';
import '../../../../../../../shared/providers/base_currency_pod/base_currency_pod.dart';

class EmptyPortfolioBody extends HookWidget {
  const EmptyPortfolioBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final baseCurrency = useProvider(baseCurrencyPod);
    final deviceSize = useProvider(deviceSizePod);

    return SPaddingH24(
      child: Column(
        children: [
          const Spacer(),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              deviceSize.when(
                small: () {
                  return Image.asset(
                    simpleEllipseAsset,
                    width: 160,
                  );
                },
                medium: () {
                  return Image.asset(
                    simpleEllipseAsset,
                    width: 320,
                  );
                },
              ),
              Center(
                child: Text(
                  volumeFormat(
                    decimal: Decimal.zero,
                    accuracy: baseCurrency.accuracy,
                    symbol: baseCurrency.symbol,
                    prefix: baseCurrency.prefix,
                  ),
                  style: sTextH0Style.copyWith(
                    color: colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SpaceH42(),
          Text(
            intl.emptyEarnWalletBody_mainText1,
            textAlign: TextAlign.center,
            style: sTextH3Style,
          ),
          Text(
            intl.emptyEarnWalletBody_mainText2,
            textAlign: TextAlign.center,
            style: sTextH3Style.copyWith(
              color: colors.blue,
            ),
          ),
          const SpaceH70(),
          SPrimaryButton1(
            active: true,
            name: intl.emptyEarnWalletBody_buyWithCash,
            onTap: () {
              showBuyAction(
                shouldPop: false,
                fromCard: true,
                context: context,
                  from:Source.profile,
              );
            },
          ),
          const SpaceH24(),
        ],
      ),
    );
  }
}
