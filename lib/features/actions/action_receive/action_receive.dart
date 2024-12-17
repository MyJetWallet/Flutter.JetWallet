import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/anchors/models/crypto_deposit/crypto_deposit_model.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/actions/helpers/show_currency_search.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../utils/models/currency_model.dart';

void showReceiveAction(BuildContext context) {
  final isReceiveMethodsAvailable = sSignalRModules.currenciesList.any((element) => element.supportsCryptoDeposit);

  if (isReceiveMethodsAvailable) {
    showSendTimerAlertOr(
      context: context,
      or: () {
        showCryptoReceiveAction(context);
      },
      from: [BlockingType.deposit],
    );
  } else {
    sNotification.showError(
      intl.operation_bloked_text,
      id: 1,
    );
  }
}

void showCryptoReceiveAction(BuildContext context) {
  final searchStore = getIt.get<ActionSearchStore>();
  searchStore.init();

  sAnalytics.chooseAssetToReceiveScreenView();

  final showSearch = showReceiveCurrencySearch(context);

  // TODO (Yaroslav): fix overflow
  showBasicBottomSheet(
    context: context,
    header: BasicBottomSheetHeaderWidget(
      title: intl.actionReceive_bottomSheetHeaderName1,
      searchOptions: showSearch
          ? SearchOptions(
              hint: intl.actionBottomSheetHeader_search,
              onChange: (String value) {
                searchStore.search(value);
              },
            )
          : null,
    ),
    expanded: true,
    children: [
      _ActionReceive(
        searchStore: searchStore,
      ),
    ],
  );
}

class _ActionReceive extends StatelessObserverWidget {
  const _ActionReceive({
    required this.searchStore,
  });

  final ActionSearchStore searchStore;

  @override
  Widget build(BuildContext context) {
    final state = searchStore;
    final watchList = sSignalRModules.keyValue.watchlist?.value ?? [];
    sortByBalanceWatchlistAndWeight(state.fCurrencies, watchList);
    var currencyFiltered = List<CurrencyModel>.from(state.fCurrencies);
    currencyFiltered = currencyFiltered
        .where(
          (element) => element.type == AssetType.crypto && element.supportsCryptoDeposit,
        )
        .toList();
    final baseCurrency = sSignalRModules.baseCurrency;

    return Column(
      children: [
        for (final currency in state.fCurrencies)
          if (currency.type == AssetType.crypto)
            if (currency.supportsCryptoDeposit)
              SimpleTableAccount(
                assetIcon: NetworkIconWidget(
                  currency.iconUrl,
                ),
                label: currency.description,
                supplement: currency.symbol,
                rightValue: getIt<AppStore>().isBalanceHide
                    ? '**** ${baseCurrency.symbol}'
                    : currency.volumeBaseBalance(baseCurrency),
                onTableAssetTap: () {
                  getIt.get<AppRouter>().push(
                        CryptoDepositRouter(
                          cryptoDepositModel: CryptoDepositModel(
                            assetSymbol: currency.symbol,
                          ),
                        ),
                      );
                },
              ),
        const SpaceH42(),
      ],
    );
  }
}
