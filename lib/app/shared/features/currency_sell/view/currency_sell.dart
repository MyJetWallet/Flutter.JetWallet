import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
import '../notifier/currency_sell_notipod.dart';

class CurrencySell extends HookWidget {
  const CurrencySell({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(currencySellNotipod(currency));
    final notifier = useProvider(currencySellNotipod(currency).notifier);
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
          text: 'For',
        ),
        children: [
          for (final currency in state.currencies)
            AssetTile(
              currency: currency,
              onTap: () => Navigator.pop(context, currency),
              selectedBorder: state.selectedCurrency == currency,
            ),
        ],
        then: (value) {
          if (value is CurrencyModel) {
            if (value != state.selectedCurrency) {
              notifier.updateTargetConversionPrice(null);
            }
            notifier.updateSelectedCurrency(value);
          } else {
            notifier.updateSelectedCurrency(null);
          }
        },
        onDissmis: () {
          Navigator.pop(context, state.selectedCurrency);
        },
      );
    }

    return PageFrame(
      header: 'Sell ${currency.description}',
      onBackButton: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          AssetInputField(
            value: fieldValue(state.inputValue, currency.symbol),
          ),
          const SpaceH8(),
          if (state.inputError.isActive)
            AssetInputError(
              text: state.inputError.value,
            )
          else ...[
            CenterAssetConversionText(
              text: '${currency.assetBalance} ${currency.symbol}',
            ),
            const SpaceH4(),
            CenterAssetConversionText(
              text: state.conversionText(),
            )
          ],
          const Spacer(),
          const AssetSelectorHeader(
            text: 'For',
          ),
          const SpaceH4(),
          if (state.selectedCurrency == null)
            AssetSelectorButton(
              name: 'Choose destination',
              onTap: () => _showAssetSheet(),
            )
          else
            AssetTile(
              priceColumn: false,
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
            name: 'Preview Sell',
            onTap: () {
              if (state.inputValid) {
                navigatorPush(
                  context,
                  ConvertPreview(
                    ConvertPreviewInput(
                      currency: currency,
                      fromAssetAmount: state.inputValue,
                      fromAssetSymbol: currency.symbol,
                      toAssetSymbol: state.selectedCurrency!.symbol,
                      assetDescription: currency.description,
                      action: TriggerAction.sell,
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
