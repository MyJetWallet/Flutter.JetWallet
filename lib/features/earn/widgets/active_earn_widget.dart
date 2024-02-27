import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/earn/widgets/earn_active_position_badge.dart';
import 'package:jetwallet/features/earn/widgets/earn_offers_list.dart';
import 'package:jetwallet/features/wallet/helper/format_date_to_hm.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/shared/simple_network_svg.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

class ActiveEarnWidget extends StatelessObserverWidget {
  const ActiveEarnWidget({super.key, required this.earnPosition});

  final EarnPositionClientModel earnPosition;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final formatService = getIt.get<FormatService>();
    final isBalanceHide = getIt<AppStore>().isBalanceHide;
    final currencies = sSignalRModules.currenciesList;

    final currency = currencies.firstWhere(
      (currency) => currency.symbol == earnPosition.offers.first.assetId,
      orElse: () => CurrencyModel.empty(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            SNetworkSvg(
              url: currency.iconUrl,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 4),
            Text(
              earnPosition.assetId,
              style: STStyles.subtitle1.copyWith(color: colors.black),
            ),
          ],
        ),
        Text(
          isBalanceHide
              ? '**** ${sSignalRModules.baseCurrency.symbol}'
              : volumeFormat(
                  decimal: formatService.convertOneCurrencyToAnotherOne(
                    fromCurrency: earnPosition.assetId,
                    fromCurrencyAmmount: earnPosition.baseAmount + earnPosition.incomeAmount,
                    toCurrency: sSignalRModules.baseCurrency.symbol,
                    baseCurrency: sSignalRModules.baseCurrency.symbol,
                    isMin: true,
                  ),
                  symbol: sSignalRModules.baseCurrency.symbol,
                  accuracy: 2,
                ),
          style: STStyles.header3.copyWith(
            color: colors.black,
          ),
        ),
        Text(
          isBalanceHide
              ? '**** ${earnPosition.assetId}'
              : volumeFormat(
                  decimal: earnPosition.baseAmount + earnPosition.incomeAmount,
                  symbol: earnPosition.assetId,
                  accuracy: currency.accuracy,
                ),
          style: STStyles.body2Medium.copyWith(
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
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      intl.earn_balance,
                      style: STStyles.body2Medium.copyWith(color: colors.grey1),
                    ),
                    Text(
                      isBalanceHide
                          ? '**** ${sSignalRModules.baseCurrency.symbol}'
                          : volumeFormat(
                              accuracy: 2,
                              decimal: formatService.convertOneCurrencyToAnotherOne(
                                fromCurrency: earnPosition.assetId,
                                fromCurrencyAmmount: earnPosition.baseAmount,
                                toCurrency: sSignalRModules.baseCurrency.symbol,
                                baseCurrency: sSignalRModules.baseCurrency.symbol,
                                isMin: true,
                              ),
                              symbol: sSignalRModules.baseCurrency.symbol,
                            ),
                      style: STStyles.subtitle2.copyWith(color: colors.black),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      isBalanceHide
                          ? '**** ${earnPosition.assetId}'
                          : volumeFormat(
                              accuracy: currency.accuracy,
                              decimal: earnPosition.baseAmount,
                              symbol: earnPosition.assetId,
                            ),
                      style: STStyles.body2Medium.copyWith(color: colors.grey1),
                      maxLines: 2,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      intl.earn_revenue,
                      style: STStyles.body2Medium.copyWith(color: colors.grey1),
                    ),
                    Text(
                      isBalanceHide
                          ? '**** ${sSignalRModules.baseCurrency.symbol}'
                          : volumeFormat(
                              accuracy: 2,
                              decimal: formatService.convertOneCurrencyToAnotherOne(
                                fromCurrency: earnPosition.assetId,
                                fromCurrencyAmmount: earnPosition.incomeAmount,
                                toCurrency: sSignalRModules.baseCurrency.symbol,
                                baseCurrency: sSignalRModules.baseCurrency.symbol,
                                isMin: true,
                              ),
                              symbol: sSignalRModules.baseCurrency.symbol,
                            ),
                      style: STStyles.subtitle2.copyWith(color: colors.black),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      isBalanceHide
                          ? '**** ${earnPosition.assetId}'
                          : volumeFormat(
                              accuracy: currency.accuracy,
                              decimal: earnPosition.incomeAmount,
                              symbol: earnPosition.assetId,
                            ),
                      style: STStyles.body2Medium.copyWith(color: colors.grey1),
                      maxLines: 2,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                if (earnPosition.closeDateTime != null && earnPosition.status == EarnPositionStatus.closing) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        intl.earn_withdrawal,
                        style: STStyles.body2Medium.copyWith(color: colors.grey1),
                      ),
                      Text(
                        intl.earn_days_left(daysLeft(earnPosition.closeDateTime ?? DateTime.now())),
                        style: STStyles.subtitle2.copyWith(color: colors.black),
                      ),
                    ],
                  ),
                ],
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
    if (earnPosition.status == EarnPositionStatus.closing) {
      return intl.earn_disbursement_is_at(
        formatDateToHmFromDate(earnPosition.closeDateTime.toString()),
        formatDateToDMYFromDate(earnPosition.closeDateTime.toString()),
      );
    }
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

  int daysLeft(DateTime to) {
    final from = DateTime.now();
    final toTemp = DateTime(to.year, to.month, to.day);
    return (toTemp.difference(from).inHours / 24).round();
  }
}
