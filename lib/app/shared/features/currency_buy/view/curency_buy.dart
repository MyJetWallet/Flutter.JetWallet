import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/components/buttons/app_button_outlined.dart';
import '../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../shared/components/spacers.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../components/asset_input_error.dart';
import '../../../components/asset_input_field.dart';
import '../../../components/asset_selector_button.dart';
import '../../../components/asset_tile/asset_tile.dart';
import '../../../components/balance_selector/view/percent_selector.dart';
import '../../../components/basic_bottom_sheet/basic_bottom_sheet.dart';
import '../../../components/convert_preview/model/convert_preview_input.dart';
import '../../../components/convert_preview/view/convert_preview.dart';
import '../../../components/number_keyboard/number_keyboard.dart';
import '../../../components/text/asset_conversion_text.dart';
import '../../../components/text/asset_selector_header.dart';
import '../../../components/text/asset_sheet_header.dart';
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

    return PageFrame(
      header: 'Buy ${currency.description}',
      onBackButton: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          AssetInputField(
            value: fieldValue(
              state.inputValue,
              state.selectedCurrencySymbol,
            ),
          ),
          const SpaceH8(),
          if (state.inputError == InputError.none)
            CenterAssetConversionText(
              text: state.conversionText(currency),
            )
          else
            AssetInputError(
              text: state.inputError.value(),
            ),
          const Spacer(),
          const AssetSelectorHeader(
            text: 'Pay from',
          ),
          const SpaceH4(),
          if (state.selectedCurrency == null)
            AssetSelectorButton(
              name: 'Choose payment method',
              onTap: () => _showAssetSheet(),
            )
          else
            AssetTile(
              headerColor: Colors.black,
              leadingAssetBalance: true,
              currency: state.selectedCurrency!,
              onTap: () => _showAssetSheet(),
            ),
          const SpaceH20(),
          PercentSelector(
            disabled: false,
            onSelection: (value) {
              notifier.selectPercentFromBalance(value);
            },
          ),
          const SpaceH10(),
          NumberKeyboard(
            onKeyPressed: (value) => notifier.updateInputValue(value),
          ),
          const SpaceH20(),
          AppButtonSolid(
            active: state.inputValid,
            name: 'Preview Buy',
            onTap: () {
              if (state.inputValid) {
                navigatorPush(
                  context,
                  ConvertPreview(
                    ConvertPreviewInput(
                      currency: currency,
                      fromAssetAmount: state.inputValue,
                      fromAssetSymbol: state.selectedCurrency!.symbol,
                      toAssetSymbol: currency.symbol,
                      toAssetDescription: currency.description,
                      action: TriggerAction.buy,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
