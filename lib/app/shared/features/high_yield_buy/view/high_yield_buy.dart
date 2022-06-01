import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/earn_offers_model.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/helpers/widget_size_from.dart';
import '../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../screens/account/components/help_center_web_view.dart';
import '../../../helpers/format_currency_string_amount.dart';
import '../../../helpers/formatting/base/volume_format.dart';
import '../../../helpers/input_helpers.dart';
import '../../../models/currency_model.dart';
import '../../market_details/view/components/about_block/components/clickable_underlined_text.dart';
import '../model/high_yield_buy_input.dart';
import '../model/preview_high_yield_buy_input.dart';
import '../notifier/high_yeild_buy_notifier/high_yield_buy_notipod.dart';
import 'preview_high_yield_buy.dart';

class HighYieldBuy extends HookWidget {
  const HighYieldBuy({
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
    final intl = useProvider(intlPod);
    final deviceSize = useProvider(deviceSizePod);
    final colors = useProvider(sColorPod);
    final input = HighYieldBuyInput(
      currency: currency,
      earnOffer: earnOffer,
    );
    final state = useProvider(highYieldBuyNotipod(input));
    final notifier = useProvider(highYieldBuyNotipod(input).notifier);
    final defaultTiers = earnOffer.tiers
        .map(
          (tier) => SimpleTierModel(
            active: tier.active,
            toUsd: tier.toUsd.toString(),
            fromUsd: tier.fromUsd.toString(),
            apy: tier.apy.toString(),
          ),
        ).toList();

    String _inputError(InputError error) {
      if (error == InputError.amountTooLarge) {
        return state.inputError.value(
          errorInfo: '${intl.earn_buy_max} ${volumeFormat(
            decimal: state.maxSubscribeAmount ?? Decimal.zero,
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

    void _showHowWeCountSheet() {
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
                  prefix: state.baseCurrency?.prefix ?? '\$',
                  decimal: Decimal.parse(state.simpleTiers[i].fromUsd),
                  accuracy: 0,
                  symbol: state.baseCurrency?.symbol ?? 'USD',
                )}-${volumeFormat(
                  prefix: state.baseCurrency?.prefix ?? '\$',
                  decimal: Decimal.parse(state.simpleTiers[i].toUsd),
                  accuracy: 0,
                  symbol: state.baseCurrency?.symbol ?? 'USD',
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
                prefix: state.baseCurrency?.prefix ?? '\$',
                decimal: Decimal.parse(state.simpleTiers[0].fromUsd),
                accuracy: 0,
                symbol: state.baseCurrency?.symbol ?? 'USD',
              )}-${volumeFormat(
                prefix: state.baseCurrency?.prefix ?? '\$',
                decimal: Decimal.parse(state.simpleTiers[0].toUsd),
                accuracy: 0,
                symbol: state.baseCurrency?.symbol ?? 'USD',
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
          if (topUp)
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
          if (topUp)
            SActionConfirmText(
              name: intl.earn_buy_current_apy,
              baseline: 34.0,
              value: state.currentApy != null ? '${state.currentApy}%' : '',
              minValueWidth: 50,
              maxValueWidth: 50,
            ),
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
          SActionConfirmText(
            name: topUp ? intl.earn_buy_top_up_apy : intl.earn_buy_your_apy,
            baseline: topUp ? 34.0 : 25.0,
            value: state.apy != null ? '${state.apy}%' : '',
            minValueWidth: 50,
            maxValueWidth: 50,
          ),
          const SpaceH19(),
          Row(
            children: [
              ClickableUnderlinedText(
                text: intl.earn_buy_learn_more,
                onTap: () {
                  HelpCenterWebView.push(
                    context: context,
                    link: infoEarnLink,
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
      header: SPaddingH24(
        child: SSmallHeader(
          title: (topUp ? intl.earn_buy_top_up : '') + earnOffer.title,
          showInfoButton: true,
          onInfoButtonTap: _showHowWeCountSheet,
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
          SHighYieldPercentageDescription(
            widgetSize: widgetSizeFrom(deviceSize),
            apy: state.apy != null
                ? '${state.apy}%'
                : '${earnOffer.currentApy}%',
            onTap: _showHowWeCountSheet,
            tiers: state.simpleTiers.isNotEmpty
                ? state.simpleTiers
                : defaultTiers,
            hot: earnOffer.offerTag == 'Hot',
            error: state.error && state.simpleTiers.isNotEmpty,
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
              notifier.selectPercentFromBalance(preset);
            },
            onKeyPressed: (value) {
              notifier.updateInputValue(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: state.inputValid && !state.error,
            submitButtonName: intl.earn_buy_preview,
            onSubmitPressed: () {
              navigatorPush(
                context,
                PreviewHighYieldBuy(
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
