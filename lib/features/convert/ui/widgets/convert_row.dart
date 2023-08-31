import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/convert/ui/widgets/widgets/convert_amount_cursor.dart';
import 'package:jetwallet/features/convert/ui/widgets/widgets/convert_auto_size_amount.dart';
import 'package:jetwallet/features/convert/ui/widgets/widgets/convert_dropdown_button.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

import '../../../../core/di/di.dart';
import '../../../../widgets/action_bottom_sheet_header.dart';
import '../../../actions/store/action_search_store.dart';

class ConvertRow extends StatelessObserverWidget {
  const ConvertRow({
    super.key,
    this.fromAsset = false,
    this.inputError,
    required this.value,
    required this.onTap,
    required this.enabled,
    required this.currency,
    required this.assetWithBalance,
    required this.assetWithoutBalance,
    required this.onDropdown,
  });

  final bool fromAsset;
  final InputError? inputError;
  final String value;
  final Function() onTap;
  final bool enabled;
  final CurrencyModel currency;
  final List<CurrencyModel> assetWithBalance;
  final List<CurrencyModel> assetWithoutBalance;
  final Function(CurrencyModel?) onDropdown;

  @override
  Widget build(BuildContext context) {
    CurrencyModel swipeCurrency = currencyFrom(
      sSignalRModules.currenciesList,
      currency.symbol,
    );

    final colors = sKit.colors;

    void _showDropdownSheet() {
      getIt.get<ActionSearchStore>().initConvert(
            assetWithBalance,
            assetWithoutBalance,
          );
      final searchStore = getIt.get<ActionSearchStore>();

      sShowBasicModalBottomSheet(
        context: context,
        scrollable: true,
        pinned: ActionBottomSheetHeader(
          name: fromAsset ? intl.from : intl.to1,
          showSearch: assetWithBalance.length + assetWithoutBalance.length > 7,
          onChanged: (String value) {
            getIt.get<ActionSearchStore>().searchConvert(
                  value,
                  assetWithBalance,
                  assetWithoutBalance,
                );
          },
          removePadding: true,
          removeSearchPadding: true,
        ),
        children: [
          _ActionConvert(
            searchStore: searchStore,
            currency: currency,
            fromAsset: fromAsset,
          ),
          const SpaceH42(),
        ],
        then: (value) {
          if (value is CurrencyModel) {
            onDropdown(value);
          }
        },
      );
    }

    return SPaddingH24(
      child: Stack(
        children: [
          SizedBox(
            height: 88.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceH22(),
                Baseline(
                  baseline: 20.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      ConvertDropdownButton(
                        onTap: () => _showDropdownSheet(),
                        currency: currency,
                      ),
                      ConvertAutoSizeAmount(
                        onTap: onTap,
                        value: value,
                        enabled: enabled,
                      ),
                      if (enabled)
                        const ConvertAmountCursor()
                      else
                        const ConvertAmountCursorPlaceholder(),
                    ],
                  ),
                ),
                Baseline(
                  baseline: 16.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Row(
                    children: [
                      const SpaceW34(),
                      if (inputError == null || inputError == InputError.none)
                        Text(
                          '${intl.convertRow_available}:'
                          ' ${swipeCurrency.volumeAssetBalance}',
                          maxLines: 1,
                          style: sBodyText2Style.copyWith(
                            color: colors.grey2,
                          ),
                        )
                      else ...[
                        const Spacer(),
                        Text(
                          inputError!.value(),
                          maxLines: 1,
                          style: sSubtitle3Style.copyWith(
                            color: colors.red,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionConvert extends StatelessObserverWidget {
  const _ActionConvert({
    super.key,
    required this.fromAsset,
    required this.searchStore,
    required this.currency,
  });

  final bool fromAsset;
  final ActionSearchStore searchStore;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final state = searchStore;
    final baseCurrency = sSignalRModules.baseCurrency;

    return Observer(
      builder: (context) {
        return Column(
          children: [
            for (final item
                in getIt.get<ActionSearchStore>().convertCurrenciesWithBalance)
              SAssetItem(
                isSelected: currency.symbol == item.symbol,
                icon: SNetworkSvg24(
                  url: item.iconUrl,
                  //color: _iconColor(item, context),
                ),
                name: item.description,
                description: item.symbol,
                amount: item.volumeBaseBalance(baseCurrency),
                removeDivider: item ==
                    getIt
                        .get<ActionSearchStore>()
                        .convertCurrenciesWithBalance
                        .last,
                onTap: () {
                  if (currency == item) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context, item);
                  }
                },
              ),
            if (!fromAsset) ...[
              const SpaceH11(),
              SDivider(
                color: sKit.colors.grey3,
              ),
              const SpaceH11(),
              for (final item in getIt
                  .get<ActionSearchStore>()
                  .convertCurrenciesWithoutBalance)
                SAssetItem(
                  isSelected: currency.symbol == item.symbol,
                  icon: SNetworkSvg24(
                    url: item.iconUrl,
                    //color: _iconColor(item, context),
                  ),
                  name: item.description,
                  description: item.symbol,
                  amount: item.volumeBaseBalance(baseCurrency),
                  removeDivider: item ==
                      getIt
                          .get<ActionSearchStore>()
                          .convertCurrenciesWithoutBalance
                          .last,
                  onTap: () {
                    if (currency == item) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context, item);
                    }
                  },
                ),
            ],
          ],
        );
      },
    );
  }

  Color? _iconColor(CurrencyModel item, BuildContext context) {
    final colors = sKit.colors;

    if (item.type == AssetType.indices) {
      return null;
    }

    return currency == item ? colors.blue : colors.black;
  }
}
