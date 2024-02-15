import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/widgets/earn_active_position_badge.dart';
import 'package:jetwallet/features/earn/widgets/earn_offers_list.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/shared/simple_network_svg.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

class ActiveEarnWidget extends StatelessWidget {
  const ActiveEarnWidget({super.key, required this.earnPosition});

  final EarnPositionClientModel earnPosition;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final formatService = getIt.get<FormatService>();
    final currencies = sSignalRModules.currenciesList;

    final currency = currencies.firstWhere(
      (currency) => currency.symbol == earnPosition.offers.first.assetId,
      orElse: () => CurrencyModel.empty(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SNetworkSvg(
              url: currency.iconUrl,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                earnPosition.assetId,
                style: STStyles.subtitle1.copyWith(color: colors.black),
              ),
            ),
          ],
        ),
        Text(
          volumeFormat(
            decimal: earnPosition.baseAmount,
            symbol: sSignalRModules.baseCurrency.symbol,
          ),
          style: STStyles.header3.copyWith(
            color: colors.black,
          ),
        ),
        Text(
          volumeFormat(
            decimal: formatService.convertOneCurrencyToAnotherOne(
              fromCurrency: sSignalRModules.baseCurrency.symbol,
              fromCurrencyAmmount: earnPosition.baseAmount,
              toCurrency: earnPosition.assetId,
              baseCurrency: sSignalRModules.baseCurrency.symbol,
              isMin: true,
              numbersAfterDot: 2,
            ),
            symbol: earnPosition.assetId,
          ),
          style: STStyles.body1Semibold.copyWith(
            color: colors.grey1,
          ),
        ),
        const SizedBox(height: 24),
        SEarnPositionBadge(status: earnPosition.status),
        const SizedBox(height: 24),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.grey5,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      intl.earn_balance,
                      style: STStyles.body2Medium.copyWith(color: colors.grey1),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          volumeFormat(
                            decimal: earnPosition.baseAmount,
                            symbol: sSignalRModules.baseCurrency.symbol,
                          ),
                          style: STStyles.subtitle2.copyWith(color: colors.black),
                        ),
                        Text(
                          volumeFormat(
                            decimal: formatService.convertOneCurrencyToAnotherOne(
                              fromCurrency: sSignalRModules.baseCurrency.symbol,
                              fromCurrencyAmmount: earnPosition.baseAmount,
                              toCurrency: earnPosition.assetId,
                              baseCurrency: sSignalRModules.baseCurrency.symbol,
                              isMin: true,
                              numbersAfterDot: 2,
                            ),
                            symbol: earnPosition.assetId,
                          ),
                          style: STStyles.body2Medium.copyWith(color: colors.grey1),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      intl.earn_revenue,
                      style: STStyles.body2Medium.copyWith(color: colors.grey1),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          volumeFormat(
                            decimal: earnPosition.incomeAmount,
                            symbol: sSignalRModules.baseCurrency.symbol,
                          ),
                          style: STStyles.subtitle2.copyWith(color: colors.black),
                        ),
                        Text(
                          volumeFormat(
                            decimal: formatService.convertOneCurrencyToAnotherOne(
                              fromCurrency: sSignalRModules.baseCurrency.symbol,
                              fromCurrencyAmmount: earnPosition.incomeAmount,
                              toCurrency: earnPosition.assetId,
                              baseCurrency: sSignalRModules.baseCurrency.symbol,
                              isMin: true,
                              numbersAfterDot: 2,
                            ),
                            symbol: earnPosition.assetId,
                          ),
                          style: STStyles.body2Medium.copyWith(color: colors.grey1),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      intl.earn_variable_apy,
                      style: STStyles.body2Medium.copyWith(color: colors.grey1),
                    ),
                    Text(
                      '${getHighestApyRateAsString(earnPosition.offers)} %',
                      style: STStyles.subtitle2.copyWith(color: colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (earnPosition.startDateTime != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        intl.earn_started,
                        style: STStyles.body2Medium.copyWith(color: colors.grey1),
                      ),
                      Text(
                        DateFormat('dd.MM.yyyy').format(earnPosition.startDateTime!),
                        style: STStyles.subtitle2.copyWith(color: colors.black),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            getWithdrawalMessage(earnPosition),
            style: STStyles.captionMedium.copyWith(color: colors.grey2),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  String getWithdrawalMessage(EarnPositionClientModel earnPosition) {
    if (earnPosition.offers.isNotEmpty) {
      final firstOffer = earnPosition.offers.first;
      if (firstOffer.withdrawType == WithdrawType.instant) {
        return intl.earn_you_can_withdraw_deposit_funds_instantly;
      } else if (firstOffer.withdrawType == WithdrawType.lock && firstOffer.lockPeriod != null) {
        return intl.earn_funds_will_be_withdrawn(firstOffer.lockPeriod!);
      }
    }
    return '';
  }

  String getHighestApyRateAsString(List<EarnOfferClientModel> offers) {
    final highestApy = offers.fold<Decimal?>(null, (max, offer) {
      if (offer.apyRate != null) {
        return max == null ? offer.apyRate : Decimal.zero;
      }
      return max;
    });

    final finalRate = formatApyRate(highestApy);
    return finalRate.toString();
  }
}
