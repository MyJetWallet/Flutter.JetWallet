import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/helper/format_day_percentage_change.dart';
import 'package:jetwallet/features/wallet/helper/show_interest_rate.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

class WalletCard extends StatelessObserverWidget {
  const WalletCard({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;
    final earnOffers = sSignalRModules.earnOffersList;
    final earnProfile = sSignalRModules.earnProfile;

    final filteredEarnOffers = earnOffers
        .where(
          (element) => element.asset == currency.symbol,
        )
        .toList();
    final filteredActiveEarnOffers = filteredEarnOffers
        .where(
          (element) => element.amount > Decimal.zero,
        )
        .toList();
    final interestRateText = filteredActiveEarnOffers.isEmpty
        ? intl.earn_title
        : filteredActiveEarnOffers.length == 1
            ? '${filteredActiveEarnOffers[0].currentApy}%'
            : '${intl.earn_title}: ${filteredActiveEarnOffers.length}';
    final interestRateDisabledText = '+${volumeFormat(
      prefix: baseCurrency.prefix,
      decimal: currency.baseTotalEarnAmount,
      accuracy: baseCurrency.accuracy,
      symbol: baseCurrency.symbol,
    )}';
    final isInterestRateDisabledVisible = currency.apy > Decimal.zero &&
        !(currency.assetBalance == Decimal.zero && currency.isPendingDeposit);
    final earnEnabled = earnProfile?.earnEnabled ?? false;
    final interestRateTextSize = _textSize(
          interestRateText,
          sSubtitle3Style,
        ).width +
        20;
    final interestRateDisabledTextSize = _textSize(
          interestRateDisabledText,
          sSubtitle3Style,
        ).width +
        20;
    final isInterestRateVisible = filteredEarnOffers.isNotEmpty;
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
              right: earnEnabled
                  ? interestRateTextSize
                  : interestRateDisabledTextSize,
            ),
            child: SBaselineChild(
              baseline: 50,
              child: Text(
                currency.description,
                style: sSubtitle2Style,
              ),
            ),
          ),
          if (earnEnabled
              ? isInterestRateVisible
              : isInterestRateDisabledVisible)
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
                  width: earnEnabled
                      ? interestRateTextSize
                      : interestRateDisabledTextSize,
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
                      earnEnabled ? interestRateText : interestRateDisabledText,
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
