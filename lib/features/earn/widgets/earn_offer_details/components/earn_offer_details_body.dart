import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/wallet/helper/format_date_to_hm.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/transaction_details_item.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/transaction_details_name_text.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/transaction_details_value_text.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';

import '../../earn_details_manage/earn_details_manage.dart';
import 'earn_details_how_we_count.dart';

class EarnOfferDetailsBody extends StatelessObserverWidget {
  const EarnOfferDetailsBody({
    Key? key,
    required this.earnOffer,
  }) : super(key: key);

  final EarnOfferModel earnOffer;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final currencies = sSignalRModules.currenciesList;
    final baseCurrency = sSignalRModules.baseCurrency;

    final currentCurrency = currencyFrom(currencies, earnOffer.asset);

    final isHot = earnOffer.offerTag == 'Hot';

    final tiers = earnOffer.tiers
        .map(
          (tier) => SimpleTierModel(
            active: tier.active,
            to: tier.to.toString(),
            from: tier.from.toString(),
            apy: tier.apy.toString(),
          ),
        )
        .toList();

    Decimal convertBaseRateToCurrency() {
      final converted = double.parse('${earnOffer.totalEarned}') /
          double.parse('${currentCurrency.currentPrice}');

      return Decimal.parse('$converted');
    }

    return SPaddingH24(
      child: Column(
        children: [
          const SpaceH42(),
          Column(
            children: [
              AutoSizeText(
                volumeFormat(
                  decimal: earnOffer.amount,
                  accuracy: currentCurrency.accuracy,
                  symbol: currentCurrency.symbol,
                ),
                textAlign: TextAlign.center,
                minFontSize: 4.0,
                maxLines: 1,
                strutStyle: const StrutStyle(
                  height: 1.20,
                  fontSize: 40.0,
                  fontFamily: 'Gilroy',
                ),
                style: TextStyle(
                  height: 1.20,
                  fontSize: 40.0,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  color: colors.black,
                ),
              ),
              Text(
                volumeFormat(
                  prefix: baseCurrency.prefix,
                  decimal: earnOffer.amountBaseAsset,
                  accuracy: baseCurrency.accuracy,
                  symbol: baseCurrency.symbol,
                ),
                style: sBodyText2Style.copyWith(
                  color: colors.grey1,
                ),
              ),
            ],
          ),
          const SpaceH32(),
          TransactionDetailsItem(
            text: intl.earn_details_start,
            value: TransactionDetailsValueText(
              text: formatDateToDMonthYFromDate(earnOffer.startDate),
            ),
          ),
          if (!isHot) ...[
            const SpaceH14(),
            TransactionDetailsItem(
              text: intl.earn_details_term,
              value: TransactionDetailsValueText(
                text: earnOffer.term,
              ),
            ),
          ],
          if (isHot && earnOffer.endDate != null) ...[
            const SpaceH14(),
            TransactionDetailsItem(
              text: intl.earn_expiry_date,
              value: TransactionDetailsValueText(
                text: formatDateToDMonthYFromDate(earnOffer.endDate!),
              ),
            ),
          ],
          const SpaceH14(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TransactionDetailsNameText(text: intl.earn_details_apy),
                  const SpaceW12(),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 3,
                    ),
                    child: STransparentInkWell(
                      onTap: () {
                        showDetailsHowWeCountSheet(
                          context: context,
                          tiers: tiers,
                          colors: colors,
                          isHot: isHot,
                          title: intl.earn_buy_annual_calculation_plan,
                          subtitle: intl.earn_buy_annual_percentage_yield,
                          currency: currentCurrency,
                        );
                      },
                      child: SInfoIcon(
                        color: colors.grey3,
                      ),
                    ),
                  ),
                ],
              ),
              TransactionDetailsValueText(
                text: '${earnOffer.currentApy}%',
              ),
            ],
          ),
          const SpaceH32(),
          Row(
            children: [
              SimplePercentageIndicator(
                tiers: tiers,
                isHot: isHot,
                expanded: true,
              ),
            ],
          ),
          const SpaceH22(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TransactionDetailsNameText(
                text: isHot
                    ? intl.earn_expected_profit
                    : intl.earn_details_interest,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isHot
                        ? volumeFormat(
                            decimal: convertBaseRateToCurrency(),
                            accuracy: currentCurrency.accuracy,
                            symbol: currentCurrency.symbol,
                          )
                        : volumeFormat(
                            prefix: baseCurrency.prefix,
                            decimal: earnOffer.totalEarned,
                            accuracy: baseCurrency.accuracy,
                            symbol: baseCurrency.symbol,
                          ),
                    style: sSubtitle3Style.copyWith(
                      color: isHot ? colors.black : colors.green,
                    ),
                  ),
                  Text(
                    isHot
                        ? '${intl.earn_aprox} ${volumeFormat(
                            prefix: baseCurrency.prefix,
                            decimal: earnOffer.totalEarned,
                            accuracy: baseCurrency.accuracy,
                            symbol: baseCurrency.symbol,
                          )}'
                        : volumeFormat(
                            decimal: convertBaseRateToCurrency(),
                            accuracy: currentCurrency.accuracy,
                            symbol: currentCurrency.symbol,
                          ),
                    style: sBodyText2Style.copyWith(
                      color: colors.grey1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SpaceH34(),
          if (earnOffer.withdrawalEnabled || earnOffer.topUpEnabled) ...[
            SSecondaryButton1(
              active: true,
              name: intl.earn_manage,
              onTap: () {
                showEarnDetailsManage(
                  context: context,
                  earnOffer: earnOffer,
                  assetName: currentCurrency.description,
                );
              },
            ),
            const SpaceH24(),
          ],
        ],
      ),
    );
  }
}
