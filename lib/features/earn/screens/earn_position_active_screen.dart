import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/earn/widgets/earn_active_position_badge.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/shared/simple_network_svg.dart';
import 'package:simple_kit_updated/widgets/button/main/simple_button.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_basic_appbar.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

@RoutePage(name: 'EarnPositionActiveRouter')
class EarnPositionActiveScreen extends StatelessWidget {
  const EarnPositionActiveScreen({required this.earnPosition, super.key});

  final EarnPositionClientModel earnPosition;

  @override
  Widget build(BuildContext context) {
    return Provider<EarnStore>(
      create: (context) => EarnStore(),
      builder: (context, child) {
        final colors = SColorsLight();
        final formatService = getIt.get<FormatService>();
        final currencies = sSignalRModules.currenciesList;

        final currency = currencies.firstWhere(
          (currency) => currency.symbol == earnPosition.offers.first.assetId,
          orElse: () => CurrencyModel.empty(),
        );

        return Scaffold(
          body: Column(
            children: [
              GlobalBasicAppBar(
                hasRightIcon: false,
                title: currency.description,
                subtitle: earnPosition.offers.first.name,
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                      ),

                      //! Plsease create new widget with needed params 
                      //! and name it ActiveEarnPositionView
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //! icon
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
                          //! Amount
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
                          //! Status
                          const SizedBox(height: 24),
                          SEarnPositionBadge(status: earnPosition.status),
                          const SizedBox(height: 24),

                          //! Info Prices
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: colors.grey5,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  //! balance
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
                                  //! revenue
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
                                  //! Variable APY
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
                                  //! Started
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
                              //! Alex S. don't use hardcoded value
                              intl.earn_funds_will_be_withdrawn(4),
                              style: STStyles.captionMedium.copyWith(color: colors.grey2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 24,
                  left: 24,
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  children: [
                    SButton.blue(
                      text: intl.earn_top_up,
                      callback: () {},
                    ),
                    const SizedBox(height: 8),
                    SButton.text(
                      text: intl.earn_withdraw,
                      callback: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String getHighestApyRateAsString(List<EarnOfferClientModel> offers) {
    final highestApy = offers.fold<Decimal?>(null, (max, offer) {
      if (offer.apyRate != null) {
        return max == null ? offer.apyRate : Decimal.zero;
      }
      return max;
    });

    return highestApy.toString();
  }
}
