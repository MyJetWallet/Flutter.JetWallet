import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../screens/market/helper/format_day_percentage_change.dart';
import '../../../components/info_web_view.dart';
import '../../../helpers/formatting/formatting.dart';
import '../../../helpers/price_accuracy.dart';
import '../../../models/currency_model.dart';
import '../../../providers/base_currency_pod/base_currency_model.dart';

// TODO: Refactor
void showInterestRate({
  required BuildContext context,
  required CurrencyModel currency,
  required BaseCurrencyModel baseCurrency,
  required SimpleColors colors,
  required Color colorDayPercentage,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    removeBarPadding: true,
    horizontalPadding: 24,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 28,
            child: Baseline(
              baseline: 28,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                marketFormat(
                  prefix: baseCurrency.prefix,
                  decimal: currency.currentPrice,
                  accuracy: priceAccuracy(
                    context.read,
                    currency.symbol,
                    baseCurrency.symbol,
                  ),
                  symbol: baseCurrency.symbol,
                ),
                style: sSubtitle3Style,
              ),
            ),
          ),
          SizedBox(
            height: 28,
            child: Baseline(
              baseline: 28,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                ' (${formatDayPercentageChange(currency.dayPercentChange)}'
                ')',
                style: sSubtitle3Style.copyWith(
                  color: colorDayPercentage,
                ),
              ),
            ),
          ),
        ],
      ),
      Center(
        child: SizedBox(
          height: 83,
          child: Baseline(
            baseline: 80,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              currency.description,
              style: sSubtitle2Style,
            ),
          ),
        ),
      ),
      Center(
        child: SizedBox(
          height: 48,
          child: Baseline(
            baseline: 46,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              currency.volumeBaseBalance(baseCurrency),
              style: sTextH1Style,
            ),
          ),
        ),
      ),
      Center(
        child: SizedBox(
          height: 24,
          child: Baseline(
            baseline: 20,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              currency.volumeAssetBalance,
              style: sBodyText2Style.copyWith(
                color: colors.grey1,
              ),
            ),
          ),
        ),
      ),
      const SpaceH90(),
      SizedBox(
        height: 44,
        child: Baseline(
          baselineType: TextBaseline.alphabetic,
          baseline: 40,
          child: Row(
            children: [
              Text(
                'Interest earned',
                style: sBodyText2Style,
              ),
              const SpaceW10(),
              if (infoEarnLink.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: STransparentInkWell(
                    onTap: () {
                      navigatorPush(context, InfoWebView(
                        link: infoEarnLink,
                        title: 'Interest earned',
                      ),);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const SInfoIcon(),
                    ),
                  ),
                ),
              const Spacer(),
              Text(
                volumeFormat(
                  prefix: baseCurrency.prefix,
                  decimal: currency.baseTotalEarnAmount,
                  accuracy: baseCurrency.accuracy,
                  symbol: baseCurrency.symbol,
                ),
                style: sBodyText1Style.copyWith(
                  color: colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: SizedBox(
          height: 20,
          child: Baseline(
            baseline: 14,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              volumeFormat(
                symbol: currency.symbol,
                decimal: currency.assetTotalEarnAmount,
                accuracy: currency.accuracy,
                prefix: currency.prefixSymbol,
              ),
              style: sBodyText2Style.copyWith(
                color: colors.grey1,
              ),
            ),
          ),
        ),
      ),
      Row(
        children: [
          SizedBox(
            height: 30,
            child: Baseline(
              baseline: 26,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                'Next pay',
                style: sBodyText2Style.copyWith(
                  color: colors.grey1,
                ),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 30,
            child: Baseline(
              baseline: 26,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                '${DateFormat('d MMM').format(
                  DateTime.parse(currency.nextPaymentDate).toLocal(),
                )}, ${volumeFormat(
                  prefix: baseCurrency.prefix,
                  decimal: currency.baseCurrentEarnAmount,
                  accuracy: baseCurrency.accuracy,
                  symbol: baseCurrency.symbol,
                )}',
                style: sBodyText1Style,
              ),
            ),
          ),
        ],
      ),
      Row(
        children: [
          SizedBox(
            height: 30,
            child: Baseline(
              baseline: 26,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                'APY',
                style: sBodyText2Style.copyWith(
                  color: colors.grey1,
                ),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 30,
            child: Baseline(
              baseline: 26,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                '${currency.apy.toBigInt()}%',
                style: sBodyText1Style,
              ),
            ),
          ),
        ],
      ),
      const SpaceH42(),
    ],
  );
}
