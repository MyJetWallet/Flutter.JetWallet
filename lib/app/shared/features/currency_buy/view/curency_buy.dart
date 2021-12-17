import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../helpers/format_currency_string_amount.dart';
import '../../../helpers/input_helpers.dart';
import '../../../models/currency_model.dart';
import '../../../providers/converstion_price_pod/conversion_price_input.dart';
import '../../../providers/converstion_price_pod/conversion_price_pod.dart';
import '../model/preview_buy_with_asset_input.dart';
import '../notifier/currency_buy_notifier/currency_buy_notipod.dart';
import 'preview_buy_with_asset.dart';

class CurrencyBuy extends HookWidget {
  const CurrencyBuy({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final state = useProvider(currencyBuyNotipod(currency));
    final notifier = useProvider(currencyBuyNotipod(currency).notifier);
    useProvider(
      conversionPriceFpod(
        ConversionPriceInput(
          baseAssetSymbol: currency.symbol,
          quotedAssetSymbol: state.selectedCurrencySymbol,
          then: notifier.updateTargetConversionPrice,
        ),
      ),
    );

    void _showAssetSelector() {
      sShowBasicModalBottomSheet(
        scrollable: true,
        pinned: const SBottomSheetHeader(
          name: 'Pay from',
        ),
        children: [
          for (final currency in state.currencies)
            if (currency.type == AssetType.crypto)
              SAssetItem(
                isSelected: currency == state.selectedCurrency,
                icon: SNetworkSvg24(
                  color: currency == state.selectedCurrency
                      ? colors.blue
                      : colors.black,
                  url: currency.iconUrl,
                ),
                name: currency.description,
                amount: currency.formatBaseBalance(
                  state.baseCurrency!,
                ),
                description: currency.formattedAssetBalance,
                onTap: () => Navigator.pop(context, currency),
              )
            else
              SFiatItem(
                isSelected: currency == state.selectedCurrency,
                icon: SNetworkSvg24(
                  color: currency == state.selectedCurrency
                      ? colors.blue
                      : colors.black,
                  url: currency.iconUrl,
                ),
                name: currency.description,
                amount: currency.formatBaseBalance(
                  state.baseCurrency!,
                ),
                onTap: () => Navigator.pop(context, currency),
              ),
          const SpaceH40(),
        ],
        context: context,
        then: (value) {
          if (value is CurrencyModel) {
            if (value != state.selectedCurrency) {
              if (value.symbol != state.baseCurrency!.symbol) {
                notifier.updateTargetConversionPrice(null);
              }
              notifier.updateSelectedCurrency(value);
              notifier.resetValuesToZero();
            }
          }
        },
      );
    }

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: 'Buy ${currency.description}',
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              SActionPriceField(
                price: formatCurrencyStringAmount(
                  prefix: state.selectedCurrency?.prefixSymbol,
                  value: state.inputValue,
                  symbol: state.selectedCurrencySymbol,
                ),
                helper: state.conversionText(currency),
                error: state.inputError.value,
                isErrorActive: state.inputError.isActive,
              ),
              const Spacer(),
              if (state.selectedCurrency == null)
                SPaymentSelectDefault(
                  icon: const SActionBuyIcon(),
                  name: 'Choose payment method',
                  onTap: () => _showAssetSelector(),
                )
              else if (state.selectedCurrency!.type == AssetType.crypto)
                SPaymentSelectAsset(
                  icon: SNetworkSvg24(
                    url: state.selectedCurrency!.iconUrl,
                  ),
                  name: state.selectedCurrency!.description,
                  amount: state.selectedCurrency!.formatBaseBalance(
                    state.baseCurrency!,
                  ),
                  description: state.selectedCurrency!.formattedAssetBalance,
                  onTap: () => _showAssetSelector(),
                )
              else
                SPaymentSelectFiat(
                  icon: SNetworkSvg24(
                    url: state.selectedCurrency!.iconUrl,
                  ),
                  name: state.selectedCurrency!.description,
                  amount: state.selectedCurrency!.formatBaseBalance(
                    state.baseCurrency!,
                  ),
                  onTap: () => _showAssetSelector(),
                ),
              const SpaceH20(),
              SNumericKeyboardAmount(
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
                submitButtonName: 'Preview Buy',
                onSubmitPressed: () {
                  navigatorPush(
                    context,
                    PreviewBuyWithAsset(
                      input: PreviewBuyWithAssetInput(
                        amount: state.inputValue,
                        fromCurrency: state.selectedCurrency!,
                        toCurrency: currency,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
