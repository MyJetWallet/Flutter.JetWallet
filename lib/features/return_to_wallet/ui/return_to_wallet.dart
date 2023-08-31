import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/return_to_wallet/model/preview_return_to_wallet_input.dart';
import 'package:jetwallet/features/return_to_wallet/model/return_to_wallet_input.dart';
import 'package:jetwallet/features/return_to_wallet/store/return_to_wallet_store.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';

@RoutePage(name: 'ReturnToWalletRouter')
class ReturnToWallet extends StatelessWidget {
  const ReturnToWallet({
    super.key,
    required this.currency,
    required this.earnOffer,
  });

  final CurrencyModel currency;
  final EarnOfferModel earnOffer;

  @override
  Widget build(BuildContext context) {
    final input = ReturnToWalletInput(
      currency: currency,
      earnOffer: earnOffer,
    );

    return Provider<ReturnToWalletStore>(
      create: (_) => ReturnToWalletStore(input),
      builder: (context, child) => _ReturnToWalletBody(
        currency: currency,
        earnOffer: earnOffer,
      ),
    );
  }
}

class _ReturnToWalletBody extends StatelessObserverWidget {
  const _ReturnToWalletBody({
    super.key,
    required this.currency,
    required this.earnOffer,
  });

  final CurrencyModel currency;
  final EarnOfferModel earnOffer;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final state = ReturnToWalletStore.of(context);

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
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
              state.tapPreset(
                preset.index == 0
                    ? '25%'
                    : preset.index == 1
                        ? '50%'
                        : 'Max',
              );
              state.selectPercentFromBalance(preset);
            },
            onKeyPressed: (value) {
              state.updateInputValue(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: state.inputValid,
            submitButtonName: intl.return_to_wallet_preview,
            onSubmitPressed: () {
              sRouter.push(
                PreviewReturnToWalletRouter(
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
