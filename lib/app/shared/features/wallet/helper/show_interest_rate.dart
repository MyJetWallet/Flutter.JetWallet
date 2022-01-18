import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../screens/market/helper/format_day_percentage_change.dart';
import '../../../helpers/format_currency_amount.dart';
import '../../../models/currency_model.dart';
import '../../../providers/base_currency_pod/base_currency_model.dart';

void showInterestRate({
  required BuildContext context,
  required CurrencyModel currency,
  required BaseCurrencyModel baseCurrency,
  required SimpleColors colors,
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
                formatCurrencyAmount(
                  prefix: baseCurrency.prefix,
                  value: currency.currentPrice,
                  accuracy: baseCurrency.accuracy,
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
                style: sSubtitle3Style.copyWith(color: colors.green),
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
              formatCurrencyAmount(
                prefix: baseCurrency.prefix,
                value: currency.baseBalance,
                accuracy: baseCurrency.accuracy,
                symbol: baseCurrency.symbol,
              ),
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
              formatCurrencyAmount(
                symbol: currency.symbol,
                value: currency.assetBalance,
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
      const SpaceH90(),
      SizedBox(
        height: 24,
        child: Baseline(
          baselineType: TextBaseline.alphabetic,
          baseline: 20,
          child: Row(
            children: [
              Text(
                'Interest earned',
                style: sBodyText2Style,
              ),
              const SpaceW10(),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: STransparentInkWell(
                  onTap: () {
                    // TODO(Vova): Open webview on tap
                  },
                  child: const SInfoIcon(),
                ),
              ),
              const Spacer(),
              Text(
                formatCurrencyAmount(
                  prefix: baseCurrency.prefix,
                  value: currency.baseTotalEarnAmount,
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
              formatCurrencyAmount(
                symbol: currency.symbol,
                value: currency.assetTotalEarnAmount,
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
                )}, ${formatCurrencyAmount(
                  prefix: baseCurrency.prefix,
                  value: currency.baseCurrentEarnAmount,
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
                '${currency.apy.toInt()}%',
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
