import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/components/buttons/app_button_outlined.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../components/asset_tile/asset_tile.dart';
import '../../../components/basic_bottom_sheet/basic_bottom_sheet.dart';
import '../../../components/convert_preview/model/convert_preview_input.dart';
import '../../../components/convert_preview/view/convert_preview.dart';
import '../../../components/text/asset_sheet_header.dart';
import '../../../helpers/format_currency_string_amount.dart';
import '../../../helpers/input_helpers.dart';
import '../../../models/currency_model.dart';
import '../../../providers/converstion_price_pod/conversion_price_input.dart';
import '../../../providers/converstion_price_pod/conversion_price_pod.dart';
import '../notifier/currency_buy_notipod.dart';

class CurrencyBuy extends HookWidget {
  const CurrencyBuy({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
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

    // TODO: finish  function
    void _showAssetSelector() {
      sShowBasicModalBottomSheet(
        children: [
          for (final currency in state.currencies)
            SAssetItem(
              icon: NetworkSvgW24(
                url: currency.iconUrl,
              ),
              name: currency.description,
              amount: currency.formatBaseBalance(
                state.baseCurrency!,
              ),
              description: currency.formattedAssetBalance,
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
        onDissmis: () {
          Navigator.pop(context, state.selectedCurrency);
        },
      );
    }
    
    /// TODO(Eli): remove in the next pr
    // ignore: unused_element
    void _showAssetSheet() {
      showBasicBottomSheet(
        context: context,
        scrollable: true,
        color: const Color(0xFF4F4F4F),
        pinned: const AssetSheetHeader(
          text: 'Pay from',
        ),
        children: [
          for (final currency in state.currencies)
            AssetTile(
              currency: currency,
              onTap: () => Navigator.pop(context, currency),
              selectedBorder: state.selectedCurrency == currency,
            ),
          const SpaceH20(),
          AppButtonOutlined(
            onTap: () {},
            textColor: Colors.white,
            borderColor: Colors.grey,
            name: 'Deposit account',
          )
        ],
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
              else
                SPaymentSelectAsset(
                  icon: NetworkSvgW24(
                    url: state.selectedCurrency!.iconUrl,
                  ),
                  name: state.selectedCurrency!.description,
                  amount: state.selectedCurrency!.formatBaseBalance(
                    state.baseCurrency!,
                  ),
                  description: state.selectedCurrency!.formattedAssetBalance,
                  onTap: () => _showAssetSelector(),
                ),
              const SpaceH20(),
              SNumericKeyboardAmount(
                preset1Name: '25%',
                preset2Name: '50%',
                preset3Name: '100%',
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
                    ConvertPreview(
                      ConvertPreviewInput(
                        currency: currency,
                        fromAssetAmount: state.inputValue,
                        fromAssetSymbol: state.selectedCurrency!.symbol,
                        toAssetSymbol: currency.symbol,
                        assetDescription: currency.description,
                        action: TriggerAction.buy,
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
