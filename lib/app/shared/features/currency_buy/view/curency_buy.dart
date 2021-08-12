import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../shared/components/spacers.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../screens/market/model/currency_model.dart';
import '../../../components/asset_tile/asset_tile.dart';
import '../../../components/balance_selector/view/percent_selector.dart';
import '../../../components/basic_bottom_sheet/basic_bottom_sheet.dart';
import '../../../components/convert_preview/model/convert_preview_input.dart';
import '../../../components/convert_preview/view/convert_preview.dart';
import '../../../components/number_keyboard/number_keyboard.dart';
import '../../../helpers/input_helpers.dart';
import '../../../providers/converstion_price_pod/conversion_price_input.dart';
import '../../../providers/converstion_price_pod/conversion_price_pod.dart';
import '../notifier/currency_buy_notipod.dart';
import 'components/asset_conversion_text.dart';
import 'components/asset_input.dart';
import 'components/asset_selector_header.dart';
import 'components/asset_sheet_header.dart';

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
          quotedAssetSymbol: state.selectedCurrency!.symbol,
          then: notifier.updateConversionPrice,
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
        ],
        then: (value) {
          notifier.updateConversionPrice(null);
          if (value is CurrencyModel) {
            notifier.updateSelectedCurrency(value);
          } else {
            notifier.updateSelectedCurrency(state.currencies.first);
          }
          notifier.resetValuesToZero();
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
          AssetInput(
            value: fieldValue(
              state.inputValue,
              state.selectedCurrency!,
            ),
          ),
          const SpaceH8(),
          AssetConversionText(
            text: '≈ ${state.convertedValue} ${currency.symbol}',
          ),
          const Spacer(),
          const AssetSelectorHeader(
            text: 'Pay from',
          ),
          const SpaceH4(),
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
