import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';

class WalletCard extends StatelessObserverWidget {
  const WalletCard({
    super.key,
    required this.currency,
  });

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;

    final interestRateDisabledText = '+${volumeFormat(
      prefix: baseCurrency.prefix,
      decimal: currency.baseTotalEarnAmount,
      accuracy: baseCurrency.accuracy,
      symbol: baseCurrency.symbol,
    )}';

    final interestRateDisabledTextSize = _textSize(
          interestRateDisabledText,
          sSubtitle3Style,
        ).width +
        20;
    final isInProgress =
        currency.assetBalance == Decimal.zero && currency.isPendingDeposit;

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
              right: interestRateDisabledTextSize,
            ),
            child: SBaselineChild(
              baseline: 50,
              child: Text(
                currency.description,
                style: sSubtitle2Style,
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
                isInProgress
                    ? '${intl.walletCard_balanceInProcess}...'
                    : currency.volumeBaseBalance(baseCurrency),
                style: sTextH1Style,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (!isInProgress)
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
          /*
          if (!isInProgress)
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
          */
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
