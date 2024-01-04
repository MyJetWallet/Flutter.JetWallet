import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

void showAddCashFromBottomSheet({
  required BuildContext context,
  required VoidCallback onClose,
  required SimpleBankingAccount bankingAccount,
}) {
  final baseCurrency = sSignalRModules.baseCurrency;

  final searchStore = ActionSearchStore();

  var currencyFiltered = List<CurrencyModel>.from(searchStore.fCurrencies);
  currencyFiltered = currencyFiltered
      .where(
        (element) => element.isAssetBalanceNotEmpty && element.type == AssetType.crypto,
      )
      .toList();

  final showSearch = currencyFiltered.length >= 7;

  sShowBasicModalBottomSheet(
    context: context,
    pinned: ActionBottomSheetHeader(
      name: intl.add_cash_from,
      showSearch: showSearch,
      onChanged: (String value) {
        searchStore.search(value);
      },
      horizontalDividerPadding: 24,
      addPaddingBelowTitle: true,
      isNewDesign: true,
    ),
    horizontalPinnedPadding: 0,
    removePinnedPadding: true,
    horizontalPadding: 0,
    onDissmis: onClose,
    scrollable: true,
    expanded: showSearch,
    children: [
      const SpaceH16(),
      MarketSeparator(
        text: intl.sell_amount_cryptocurrencies,
        isNeedDivider: false,
      ),
      Observer(
        builder: (context) {
          var currencyFiltered = List<CurrencyModel>.from(searchStore.fCurrencies);
          currencyFiltered = currencyFiltered
              .where(
                (element) => element.isAssetBalanceNotEmpty && element.type == AssetType.crypto,
              )
              .toList();

          return Column(
            children: [
              for (final currency in currencyFiltered)
                if (currency.isAssetBalanceNotEmpty)
                  SWalletItem(
                    decline: currency.dayPercentChange.isNegative,
                    icon: SNetworkSvg24(
                      url: currency.iconUrl,
                    ),
                    primaryText: currency.description,
                    removeDivider: true,
                    amount: currency.volumeBaseBalance(baseCurrency),
                    secondaryText: currency.volumeAssetBalance,
                    onTap: () {
                      Navigator.pop(context);
                      sRouter.push(
                        AmountRoute(
                          tab: AmountScreenTab.sell,
                          asset: currency,
                          account: bankingAccount,
                        ),
                      );
                    },
                  ),
            ],
          );
        },
      ),
      const SpaceH42(),
    ],
  );
}
