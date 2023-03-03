import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/send_alert_bottom_sheet.dart';
import 'package:jetwallet/features/actions/action_send/widgets/send_options.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/services/local_storage_service.dart';
import '../helpers/show_currency_search.dart';

void showSendAction(
  BuildContext context, {
  bool isSendAvailable = true,
  bool isNotEmptyBalance = true,
  bool shouldPop = true,
}) {
  if (shouldPop) {
    Navigator.pop(context);
  }
  final searchState = getIt.get<ActionSearchStore>();
  final sendAssets = searchState.filteredCurrencies.where(
    (element) => element.isAssetBalanceNotEmpty &&
      element.supportsCryptoWithdrawal,
  ).toList();

  if (isNotEmptyBalance && isSendAvailable && sendAssets.isNotEmpty) {
    showSendTimerAlertOr(
      context: context,
      or: () => _showSendAction(context),
    );
  } else {
    sendAlertBottomSheet(context);
  }
}

Future<void> _showSendAction(BuildContext context) async {
  final showSearch = showSendCurrencySearch(context);

  final storageService = getIt.get<LocalStorageService>();
  final lastCurrency = await storageService.getValue(lastAssetSend);

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: ActionBottomSheetHeader(
      name: intl.actionSend_bottomSheetHeaderName,
      showSearch: showSearch,
      onChanged: (String value) {
        getIt.get<ActionSearchStore>().search(value);
      },
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [_ActionSend(lastCurrency: lastCurrency)],
    then: (value) {},
  );
}

class _ActionSend extends StatelessObserverWidget {
  const _ActionSend({
    Key? key,
    this.lastCurrency,
  }) : super(key: key);

  final String? lastCurrency;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final state = getIt.get<ActionSearchStore>();
    var currencyFiltered = List<CurrencyModel>.from(state.filteredCurrencies);
    currencyFiltered = currencyFiltered.where(
      (element) => element.isAssetBalanceNotEmpty &&
          element.supportsCryptoWithdrawal,
    ).toList();
    currencyFiltered.sort((a,b) {
      if (lastCurrency != null) {
        if (a.symbol == lastCurrency) {
          return 0.compareTo(1);
        } else if (b.symbol == lastCurrency) {
          return 1.compareTo(0);
        }
      }

      return b.baseBalance.compareTo(a.baseBalance);
    });

    return Column(
      children: [
        for (final currency in currencyFiltered)
          if (currency.isAssetBalanceNotEmpty)
            if (currency.supportsCryptoWithdrawal)
              SWalletItem(
                decline: currency.dayPercentChange.isNegative,
                icon: SNetworkSvg24(
                  url: currency.iconUrl,
                ),
                primaryText: currency.description,
                removeDivider: currency == currencyFiltered.last,
                amount: currency.volumeBaseBalance(baseCurrency),
                secondaryText: currency.volumeAssetBalance,
                onTap: () {
                  showSendOptions(context, currency);
                },
              ),
        const SpaceH42(),
      ],
    );
  }
}
