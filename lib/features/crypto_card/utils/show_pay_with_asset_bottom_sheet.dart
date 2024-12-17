import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/crypto_card/store/crypto_card_pay_asset_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';

Future<void> showPayWithAssetBottomSheet({
  required BuildContext context,
  required CryptoCardPayAssetStore store,
}) async {
  await showBasicBottomSheet(
    context: context,
    expanded: store.showSearch,
    header: BasicBottomSheetHeaderWidget(
      title: intl.crypto_card_creat_choose_asset_to_buy_card,
      searchOptions: store.showSearch
          ? SearchOptions(
              hint: intl.actionBottomSheetHeader_search,
              onChange: (String value) {
                store.onCahngeSearch(value);
              },
            )
          : null,
    ),
    children: [
      _LinkedAssetBody(store),
    ],
  );

  // to clear the search after closing bottom sheet
  store.onCahngeSearch('');
}

class _LinkedAssetBody extends StatelessWidget {
  const _LinkedAssetBody(this.store);

  final CryptoCardPayAssetStore store;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final formatService = getIt.get<FormatService>();

    return Observer(
      builder: (context) {
        final assets = store.filterdAssets;
        return Column(
          children: [
            for (final asset in assets)
              SimpleTableAsset(
                assetIcon: NetworkIconWidget(
                  asset.iconUrl,
                ),
                label: asset.description,
                supplement: getIt<AppStore>().isBalanceHide ? '**** ${asset.symbol}' : asset.volumeAssetBalance,
                rightValue: getIt<AppStore>().isBalanceHide
                    ? '**** ${store.priceAsset.symbol}'
                    : formatService
                        .convertOneCurrencyToAnotherOne(
                          fromCurrency: asset.symbol,
                          fromCurrencyAmmount: asset.assetBalance,
                          toCurrency: store.priceAsset.symbol,
                          baseCurrency: baseCurrency.symbol,
                          isMin: true,
                        )
                        .toFormatSum(
                          symbol: store.priceAsset.symbol,
                          accuracy: store.priceAsset.accuracy,
                        ),
                onTableAssetTap: () {
                  Navigator.of(context).pop();
                  store.onChooseAsset(asset);
                },
              ),
            const SpaceH40(),
          ],
        );
      },
    );
  }
}
