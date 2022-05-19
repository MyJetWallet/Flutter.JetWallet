import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/earn_offers_model.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/helpers/widget_size_from.dart';
import '../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../screens/account/components/help_center_web_view.dart';
import '../../../helpers/format_currency_string_amount.dart';
import '../../../helpers/formatting/base/volume_format.dart';
import '../../../helpers/input_helpers.dart';
import '../../../models/currency_model.dart';
import '../../../providers/converstion_price_pod/conversion_price_input.dart';
import '../../../providers/converstion_price_pod/conversion_price_pod.dart';
import '../../market_details/view/components/about_block/components/clickable_underlined_text.dart';
import '../model/high_yield_buy_input.dart';
import '../model/preview_high_yield_buy_input.dart';
import '../notifier/high_yield_buy_notipod.dart';
import 'preview_high_yield_buy.dart';

class HighYieldBuy extends HookWidget {
  const HighYieldBuy({
    Key? key,
    required this.currency,
    required this.earnOffer,
  }) : super(key: key);

  final CurrencyModel currency;
  final EarnOfferModel earnOffer;

  @override
  Widget build(BuildContext context) {
    final deviceSize = useProvider(deviceSizePod);
    final colors = useProvider(sColorPod);
    final input = HighYieldBuyInput(
      currency: currency,
      earnOffer: earnOffer,
    );
    final state = useProvider(highYieldBuyNotipod(input));
    final notifier = useProvider(highYieldBuyNotipod(input).notifier);
    useProvider(
      conversionPriceFpod(
        ConversionPriceInput(
          baseAssetSymbol: currency.symbol,
          quotedAssetSymbol: state.selectedCurrencySymbol,
          then: notifier.updateTargetConversionPrice,
        ),
      ),
    );

    String _inputError(InputError error) {
      if (error == InputError.amountTooLarge) {
        return state.inputError.value(
          errorInfo: 'Max. ${volumeFormat(
            decimal: state.maxSubscribeAmount ?? Decimal.zero,
            accuracy: state.selectedCurrencyAccuracy,
            symbol: state.selectedCurrencySymbol,
          )}',
        );
      } else if (error == InputError.amountTooLow) {
        return state.inputError.value(
          errorInfo: 'Min. ${volumeFormat(
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
            child: Text(
              state.singleTier ? 'Conditions' : 'How we count',
              // 'Conditions',
              style: sTextH1Style,
            ),
          ),
          const SpaceH11(),
          Center(
            child: Text(
              'Annual percentage yield',
              style: sBodyText1Style.copyWith(
                color: colors.grey1,
              ),
            ),
          ),
          const SpaceH35(),
          Row(
            children: [
              SimplePercentageIndicator(
                tiers: state.simpleTiers,
                expanded: true,
              ),
            ],
          ),
          const SpaceH24(),
          if (!state.singleTier)
            for (var i = 0; i < state.simpleTiers.length; i++)
              SActionConfirmText(
                name: 'Tier ${i + 1} APY (limit: '
                    '${volumeFormat(
                  prefix: '\$',
                  decimal: Decimal.parse(state.simpleTiers[i].fromUsd),
                  accuracy: 0,
                  symbol: 'USD',
                )}-${volumeFormat(
                  prefix: '\$',
                  decimal: Decimal.parse(state.simpleTiers[i].toUsd),
                  accuracy: 0,
                  symbol: 'USD',
                )})',
                baseline: 35.0,
                value: '${state.simpleTiers[i].apy}%',
                valueColor: i == 0
                    ? colors.seaGreen
                    : i == 1
                        ? colors.leafGreen
                        : colors.aquaGreen,
                minValueWidth: 50,
                maxValueWidth: 50,
              )
          else ...[
            SActionConfirmText(
              name: 'Limit',
              baseline: 35.0,
              value: '${volumeFormat(
                prefix: '\$',
                decimal: Decimal.parse(state.simpleTiers[0].fromUsd),
                accuracy: 0,
                symbol: 'USD',
              )}-${volumeFormat(
                prefix: '\$',
                decimal: Decimal.parse(state.simpleTiers[0].toUsd),
                accuracy: 0,
                symbol: 'USD',
              )}',
              minValueWidth: 50,
              maxValueWidth: 200,
            ),
            SActionConfirmText(
              name: 'APY',
              baseline: 35.0,
              value: '${state.simpleTiers[0].apy}%',
              minValueWidth: 50,
              maxValueWidth: 50,
            ),
          ],
          const SpaceH35(),
          const SDivider(),
          const SpaceH25(),
          SActionConfirmText(
            name: 'Your deposit',
            baseline: 14.0,
            value: volumeFormat(
              decimal: Decimal.parse(state.inputValue),
              accuracy: state.selectedCurrencyAccuracy,
              symbol: state.selectedCurrencySymbol,
            ),
            minValueWidth: 200,
            maxValueWidth: 200,
          ),
          SActionConfirmText(
            name: 'Your APY',
            baseline: 25.0,
            value: state.apy != null ? '${state.apy}%' : '',
            minValueWidth: 50,
            maxValueWidth: 50,
          ),
          const SpaceH19(),
          Row(
            children: [
              ClickableUnderlinedText(
                text: 'Learn more',
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
          title: earnOffer.title,
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
              'Available: ${currency.volumeAssetBalance}',
              style: sSubtitle3Style.copyWith(
                color: colors.grey2,
              ),
            ),
          ),
          const Spacer(),
          SHighYieldPercentageDescription(
            widgetSize: widgetSizeFrom(deviceSize),
            apy: state.apy != null ? '${state.apy}%' : '',
            onTap: state.simpleTiers.isNotEmpty ? _showHowWeCountSheet : null,
            tiers: state.simpleTiers,
          ),
          deviceSize.when(
            small: () => const Spacer(),
            medium: () => const SpaceH20(),
          ),
          SNumericKeyboardAmount(
            widgetSize: widgetSizeFrom(deviceSize),
            preset1Name: '25%',
            preset2Name: '50%',
            preset3Name: 'MAX',
            selectedPreset: state.selectedPreset,
            onPresetChanged: (preset) {
              notifier.selectPercentFromBalance(preset);
            },
            onKeyPressed: (value) {
              notifier.updateInputValue(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: state.inputValid,
            submitButtonName: 'Preview',
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
