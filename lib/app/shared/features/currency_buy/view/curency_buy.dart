import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../shared/components/spacers.dart';
import '../../../../screens/market/model/currency_model.dart';
import '../../../components/balance_selector/view/percent_selector.dart';
import '../../../components/basic_bottom_sheet/basic_bottom_sheet.dart';
import '../../../components/number_keyboard/number_keyboard.dart';
import '../notifier/currency_buy_notipod.dart';
import 'components/asset_selector_button.dart';
import 'components/asset_selector_header.dart';
import 'components/asset_sheet_header.dart';
import 'components/asset_tile/asset_tile.dart';

class CurrencyBuy extends HookWidget {
  const CurrencyBuy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(currencyBuyNotipod);
    final notifier = useProvider(currencyBuyNotipod.notifier);

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
          if (value is CurrencyModel) {
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
      header: 'Buy Bitcoin',
      onBackButton: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              // ignore: avoid_print
              print(value);
            },
          ),
          const SpaceH10(),
          NumberKeyboard(
            onKeyPressed: (value) {
              // ignore: avoid_print
              print(value);
            },
          ),
          const SpaceH20(),
          AppButtonSolid(
            active: false,
            name: 'Preview Buy',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
