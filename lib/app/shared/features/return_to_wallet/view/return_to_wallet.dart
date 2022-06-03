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
import '../../../helpers/format_currency_string_amount.dart';
import '../../../helpers/formatting/base/market_format.dart';
import '../../../helpers/formatting/base/volume_format.dart';
import '../../../helpers/input_helpers.dart';
import '../../../models/currency_model.dart';
import '../model/preview_return_to_wallet_input.dart';
import '../model/return_to_wallet_input.dart';
import '../notifier/return_to_wallet_notifier/return_to_wallet_notipod.dart';
import 'preview_return_to_wallet.dart';

class ReturnToWallet extends HookWidget {
  const ReturnToWallet({
    Key? key,
    required this.currency,
    required this.earnOffer,
  }) : super(key: key);

  final CurrencyModel currency;
  final EarnOfferModel earnOffer;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final deviceSize = useProvider(deviceSizePod);
    final colors = useProvider(sColorPod);
    final input = ReturnToWalletInput(
      currency: currency,
      earnOffer: earnOffer,
    );
    final state = useProvider(returnToWalletNotipod(input));
    final notifier = useProvider(returnToWalletNotipod(input).notifier);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.return_to_wallet_return_to_wallet,
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
              error: state.inputError.value(
                errorInfo: '${intl.return_to_wallet_max}. ${marketFormat(
                  decimal: state.maxSubscribeAmount ?? Decimal.zero,
                  accuracy: 0,
                  symbol: state.selectedCurrencySymbol,
                )}',
              ),
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
              '${intl.return_to_wallet_available}: ${volumeFormat(
                decimal: state.currentBalance ?? Decimal.zero,
                accuracy: state.selectedCurrencyAccuracy,
                symbol: state.selectedCurrencySymbol,
              )}',
              style: sSubtitle3Style.copyWith(
                color: colors.grey2,
              ),
            ),
          ),
          const Spacer(),
          SPaymentSelectAsset(
            widgetSize: widgetSizeFrom(deviceSize),
            icon: SNetworkSvg24(
              url: currency.iconUrl,
            ),
            name: currency.description,
            amount: currency.volumeBaseBalance(
              state.baseCurrency!,
            ),
            description: currency.volumeAssetBalance,
          ),
          deviceSize.when(
            small: () => const Spacer(),
            medium: () => const SpaceH20(),
          ),
          SNumericKeyboardAmount(
            widgetSize: widgetSizeFrom(deviceSize),
            preset1Name: '25%',
            preset2Name: '50%',
            preset3Name: intl.return_to_wallet_max_preset,
            selectedPreset: state.selectedPreset,
            onPresetChanged: (preset) {
              notifier.selectPercentFromBalance(preset);
            },
            onKeyPressed: (value) {
              notifier.updateInputValue(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: state.inputValid,
            submitButtonName: intl.return_to_wallet_preview,
            onSubmitPressed: () {
              navigatorPush(
                context,
                PreviewReturnToWallet(
                  input: PreviewReturnToWalletInput(
                    remainingBalance: ((state.currentBalance ?? Decimal.zero) -
                            Decimal.parse(state.inputValue))
                        .toString(),
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
