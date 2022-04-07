import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../screens/market/helper/format_day_percentage_change.dart';
import '../../../../../../../../helpers/formatting/base/volume_format.dart';
import '../../../../../../../../helpers/formatting/formatting.dart';
import '../../../../../../../../models/currency_model.dart';
import '../../../../../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../../../helper/show_interest_rate.dart';

class WalletCard extends HookWidget {
  const WalletCard({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final baseCurrency = useProvider(baseCurrencyPod);
    final interestRateText = '+${volumeFormat(
      prefix: baseCurrency.prefix,
      decimal: currency.baseTotalEarnAmount,
      accuracy: baseCurrency.accuracy,
      symbol: baseCurrency.symbol,
    )}';
    final interestRateTextSize = _textSize(interestRateText, sSubtitle3Style);

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
            padding: EdgeInsets.only(
              left: 34,
              right: interestRateTextSize.width + 20,
            ),
            child: SBaselineChild(
              baseline: 50,
              child: Text(
                currency.description,
                style: sSubtitle2Style,
              ),
            ),
          ),
          if (currency.apy != Decimal.zero)
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  showInterestRate(
                    context: context,
                    currency: currency,
                    baseCurrency: baseCurrency,
                    colors: colors,
                    colorDayPercentage: colorDayPercentage(
                      currency.dayPercentChange,
                      colors,
                    ),
                  );
                },
                child: Container(
                  height: 24,
                  width: interestRateTextSize.width + 20,
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
                      interestRateText,
                      style: sSubtitle3Style.copyWith(
                        color: colors.white,
                      ),
                    ),
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
                currency.volumeBaseBalance(baseCurrency),
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
                currency.volumeAssetBalance,
                style: sBodyText2Style.copyWith(
                  color: colors.grey1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 20,
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () {
                  showInterestRate(
                    context: context,
                    currency: currency,
                    baseCurrency: baseCurrency,
                    colors: colors,
                    colorDayPercentage: colorDayPercentage(
                      currency.dayPercentChange,
                      colors,
                    ),
                  );
                },
                child: const SInfoIcon(),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// This function calculates size of text in pixels
// TODO(any): refactor
  Size _textSize(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size;
  }
}
