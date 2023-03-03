import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/high_yield_buy/store/high_yeild_buy_store.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/about_block/components/clickable_underlined_text.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';

import '../../earn/widgets/earn_subscription/components/subscriptions_item.dart';
import '../../earn/widgets/earn_subscription/earn_subscriptions.dart';
import '../model/high_yield_buy_input.dart';
import '../model/preview_high_yield_buy_input.dart';

class HighYieldBuy extends StatelessWidget {
  const HighYieldBuy({
    super.key,
    this.topUp = false,
    required this.currency,
    required this.earnOffer,
  });

  final CurrencyModel currency;
  final EarnOfferModel earnOffer;
  final bool topUp;

  @override
  Widget build(BuildContext context) {
    final input = HighYieldBuyInput(
      currency: currency,
      earnOffer: earnOffer,
    );

    return Provider<HighYeildBuyStore>(
      create: (context) => HighYeildBuyStore(input),
      builder: (context, child) => _HighYieldBuyBody(
        topUp: topUp,
        currency: currency,
        earnOffer: earnOffer,
      ),
    );
  }
}

class _HighYieldBuyBody extends StatelessObserverWidget {
  const _HighYieldBuyBody({
    Key? key,
    this.topUp = false,
    required this.currency,
    required this.earnOffer,
  }) : super(key: key);

  final CurrencyModel currency;
  final EarnOfferModel earnOffer;
  final bool topUp;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;
    final state = HighYeildBuyStore.of(context);
    final baseCurrency = sSignalRModules.baseCurrency;

    final defaultTiers = earnOffer.tiers
        .map(
          (tier) => SimpleTierModel(
            active: tier.active,
            to: tier.to.toString(),
            from: tier.from.toString(),
            apy: tier.apy.toString(),
          ),
        )
        .toList();

    String _inputError(InputError error) {
      if (error == InputError.amountTooLarge) {
        return state.inputError.value(
          errorInfo: '${intl.earn_buy_max} ${volumeFormat(
            decimal: Decimal.parse(
              '${(state.maxSubscribeAmount ?? Decimal.zero).toDouble() - (state.currentBalance ?? Decimal.zero).toDouble()}',
            ),
            accuracy: state.selectedCurrencyAccuracy,
            symbol: state.selectedCurrencySymbol,
          )}',
        );
      } else if (error == InputError.amountTooLow) {
        return state.inputError.value(
          errorInfo: '${intl.earn_buy_min} ${volumeFormat(
            decimal: state.minSubscribeAmount ?? Decimal.zero,
            accuracy: state.selectedCurrencyAccuracy,
            symbol: state.selectedCurrencySymbol,
          )}',
        );
      } else {
        return state.inputError.value();
      }
    }

    void _showHowWeCountSheet(String source) {
      sShowBasicModalBottomSheet(
        horizontalPadding: 24,
        children: [
          const SpaceH4(),
          Center(
            child: AutoSizeText(
              intl.earn_buy_annual_calculation_plan,
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
          ),
          const SpaceH11(),
          Center(
            child: Text(
              intl.earn_buy_annual_percentage_yield,
              style: sBodyText1Style.copyWith(
                color: colors.grey1,
              ),
            ),
          ),
          const SpaceH35(),
          Row(
            children: [
              SimplePercentageIndicator(
                tiers: state.simpleTiers.isNotEmpty
                    ? state.simpleTiers
                    : defaultTiers,
                expanded: true,
                isHot: earnOffer.offerTag == 'Hot',
              ),
            ],
          ),
          const SpaceH24(),
          if (!state.singleTier)
            for (var i = 0; i < state.simpleTiers.length; i++)
              SActionConfirmText(
                name: '${intl.earn_buy_tier} ${i + 1} ${intl.earn_buy_apy} '
                    '(${intl.earn_buy_limit}: '
                    '${volumeFormat(
                  decimal: Decimal.parse(state.simpleTiers[i].from),
                  accuracy: currency.accuracy,
                  prefix: '',
                  symbol: '',
                )}-${volumeFormat(
                  decimal: Decimal.parse(state.simpleTiers[i].to),
                  accuracy: currency.accuracy,
                  symbol: currency.symbol,
                )})',
                baseline: 35.0,
                value: '${state.simpleTiers[i].apy}%',
                valueColor: i == 0
                    ? earnOffer.offerTag == 'Hot'
                        ? colors.orange
                        : colors.seaGreen
                    : i == 1
                        ? earnOffer.offerTag == 'Hot'
                            ? colors.brown
                            : colors.leafGreen
                        : earnOffer.offerTag == 'Hot'
                            ? colors.darkBrown
                            : colors.aquaGreen,
                minValueWidth: 50,
                maxValueWidth: 50,
              )
          else ...[
            SActionConfirmText(
              name: intl.earn_buy_limit1,
              baseline: 35.0,
              value: '${volumeFormat(
                prefix: '',
                decimal: Decimal.parse(state.simpleTiers[0].from),
                accuracy: currency.accuracy,
                symbol: '',
              )}-${volumeFormat(
                decimal: Decimal.parse(state.simpleTiers[0].to),
                accuracy: currency.accuracy,
                symbol: currency.symbol,
              )}',
              minValueWidth: 50,
              maxValueWidth: 200,
            ),
            SActionConfirmText(
              name: intl.earn_buy_apy,
              baseline: 35.0,
              value: '${state.simpleTiers[0].apy}%',
              minValueWidth: 50,
              maxValueWidth: 50,
            ),
          ],
          const SpaceH35(),
          const SDivider(),
          const SpaceH25(),
          if (topUp) ...[
            SActionConfirmText(
              name: intl.earn_buy_current_balance,
              baseline: 14.0,
              value: volumeFormat(
                decimal: state.currentBalance ?? Decimal.zero,
                accuracy: state.selectedCurrencyAccuracy,
                symbol: state.selectedCurrencySymbol,
              ),
              minValueWidth: 200,
              maxValueWidth: 200,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                volumeFormat(
                  prefix: baseCurrency.prefix,
                  decimal: Decimal.parse(
                    '${(state.currentBalance ?? Decimal.zero).toDouble() * currency.currentPrice.toDouble()}',
                  ),
                  accuracy: 2,
                  symbol: baseCurrency.symbol,
                ),
                style: sBodyText2Style.copyWith(
                  color: colors.grey1,
                ),
              ),
            ),
          ],
          SActionConfirmText(
            name: topUp
                ? intl.earn_buy_top_up_amount
                : intl.earn_buy_your_deposit,
            baseline: topUp ? 34.0 : 14.0,
            value: volumeFormat(
              decimal: Decimal.parse(state.inputValue),
              accuracy: state.selectedCurrencyAccuracy,
              symbol: state.selectedCurrencySymbol,
            ),
            minValueWidth: 200,
            maxValueWidth: 200,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              volumeFormat(
                prefix: baseCurrency.prefix,
                decimal: Decimal.parse(
                  '${Decimal.parse(state.inputValue).toDouble() * currency.currentPrice.toDouble()}',
                ),
                accuracy: 2,
                symbol: baseCurrency.symbol,
              ),
              style: sBodyText2Style.copyWith(
                color: colors.grey1,
              ),
            ),
          ),
          SActionConfirmText(
            name: intl.earn_buy_interest_per_day,
            baseline: topUp ? 34.0 : 25.0,
            value: volumeFormat(
              prefix: currency.prefixSymbol,
              decimal: state.expectedDailyProfit ?? Decimal.zero,
              accuracy: currency.accuracy,
              symbol: currency.symbol,
            ),
            minValueWidth: 200,
            maxValueWidth: 200,
          ),
          const SpaceH19(),
          Row(
            children: [
              ClickableUnderlinedText(
                text: intl.earn_buy_learn_more,
                onTap: () {
                  sRouter.push(
                    HelpCenterWebViewRouter(
                      link: infoEarnLink,
                    ),
                  );
                },
              ),
            ],
          ),
          const SpaceH40(),
        ],
        context: context,
      );
    }

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: (topUp ? '${intl.earn_buy_top_up} ' : '') + earnOffer.title,
          showInfoButton: true,
          onInfoButtonTap: () {
            final source = topUp ? 'Info (Top up)' : 'Info (Subscription)';
            _showHowWeCountSheet(source);
          },
        ),
      ),
      child: Column(
        children: [
          deviceSize.when(
            small: () => const SizedBox(),
            medium: () => const Spacer(),
          ),
          Baseline(
            baseline: deviceSize.when(
              small: () => 32,
              medium: () => 9,
            ),
            baselineType: TextBaseline.alphabetic,
            child: SActionPriceField(
              widgetSize: widgetSizeFrom(deviceSize),
              price: formatCurrencyStringAmount(
                prefix: currency.prefixSymbol,
                value: state.inputValue,
                symbol: currency.symbol,
              ),
              helper: state.conversionText(),
              error: _inputError(state.inputError),
              isErrorActive: state.inputError.isActive,
            ),
          ),
          Baseline(
            baseline: deviceSize.when(
              small: () => -36,
              medium: () => 19,
            ),
            baselineType: TextBaseline.alphabetic,
            child: Text(
              '${intl.earn_buy_available}: ${currency.volumeAssetBalance}',
              style: sSubtitle3Style.copyWith(
                color: colors.grey2,
              ),
            ),
          ),
          const Spacer(),
          SPaddingH24(
            child: SubscriptionsItem(
              earnOffer: earnOffer,
              currency: currency,
              isHot: earnOffer.offerTag == 'Hot',
              days: earnOffer.endDate == null
                  ? 0
                  : calcDifference(
                      firstDate: earnOffer.startDate,
                      lastDate: earnOffer.endDate!,
                    ),
              onTap: () {
                final source = topUp ? 'Top up' : 'Subscription';
                _showHowWeCountSheet(source);
              },
            ),
          ),
          deviceSize.when(
            small: () => const Spacer(),
            medium: () => const SpaceH20(),
          ),
          SNumericKeyboardAmount(
            widgetSize: widgetSizeFrom(deviceSize),
            preset1Name: '25%',
            preset2Name: '50%',
            preset3Name: intl.earn_buy_max_preset,
            selectedPreset: state.selectedPreset,
            onPresetChanged: (preset) {
              state.tapPreset(
                preset.index == 0
                    ? '25%'
                    : preset.index == 1
                        ? '50%'
                        : 'Max',
              );
              state.selectPercentFromBalance(preset, topUp: topUp);
            },
            onKeyPressed: (value) {
              state.updateInputValue(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: state.inputValid && !state.error,
            submitButtonName: intl.earn_buy_preview,
            onSubmitPressed: () {

              sRouter.push(
                PreviewHighYieldBuyScreenRouter(
                  input: PreviewHighYieldBuyInput(
                    amount: state.inputValue,
                    fromCurrency: currency,
                    toCurrency: currency,
                    apy: state.apy.toString(),
                    expectedYearlyProfit: state.expectedYearlyProfit.toString(),
                    expectedYearlyProfitBase:
                        state.expectedYearlyProfitBaseAsset.toString(),
                    earnOffer: earnOffer,
                    topUp: topUp,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
