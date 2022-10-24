import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/actions/helpers/show_currency_search.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/24x24/light/qr_code/simple_light_qr_code_icon.dart';
import 'package:simple_kit/modules/icons/24x24/light/wallet/simple_light_wallet_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

void showReceiveAction(BuildContext context) {
  final colors = sKit.colors;

  sAnalytics.receiveChooseAsset();
  Navigator.pop(context);

  sShowBasicModalBottomSheet(
    context: context,
    then: (value) {
      //sAnalytics.receiveChooseAssetClose();
    },
    pinned: ActionBottomSheetHeader(
      name: intl.actionReceive_receive,
      onChanged: (String value) {},
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      Column(
        children: [
          SWalletItem(
            icon: const SimpleLightWalletIcon(),
            primaryText: intl.actionReceive_receive_crypto,
            secondaryText: intl.actionReceive_receive_crypto,
            onTap: () {
              showCryptoReceiveAction(context);
            },
          ),
          SWalletItem(
            icon: SimpleLightQrCodeIcon(
              color: colors.blue,
            ),
            primaryText: intl.actionReceive_receive_nft,
            secondaryText: intl.actionReceive_receive_nft,
            onTap: () {
              sRouter.push(
                const ReceiveNFTRouter(),
              );
            },
          ),
        ],
      ),
    ],
  );
}

void showCryptoReceiveAction(BuildContext context) {
  final showSearch = showReceiveCurrencySearch(context);

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    then: (value) {
      sAnalytics.receiveChooseAssetClose();
    },
    pinned: ActionBottomSheetHeader(
      name: intl.actionReceive_bottomSheetHeaderName1,
      showSearch: showSearch,
      onChanged: (String value) {
        getIt.get<ActionSearchStore>().search(value);
      },
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [const _ActionReceive()],
  );
}

class _ActionReceive extends StatelessObserverWidget {
  const _ActionReceive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = getIt.get<ActionSearchStore>()..init();
    sortByBalanceAndWeight(state.filteredCurrencies);

    return Column(
      children: [
        for (final currency in state.filteredCurrencies)
          if (currency.type == AssetType.crypto)
            if (currency.supportsCryptoDeposit)
              SWalletItem(
                icon: SNetworkSvg24(
                  url: currency.iconUrl,
                ),
                primaryText: currency.description,
                secondaryText: currency.symbol,
                removeDivider: currency == state.filteredCurrencies.last,
                onTap: () {
                  sAnalytics.receiveAssetView(asset: currency.description);

                  getIt.get<AppRouter>().push(
                        CryptoDepositRouter(
                          header: intl.actionReceive_receive,
                          currency: currency,
                        ),
                      );
                },
              ),
      ],
    );
  }
}
