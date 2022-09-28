import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/actions/action_send/widgets/send_options.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../helpers/show_currency_search.dart';

void showSendAction(BuildContext context) {
  Navigator.pop(context);

  showSendTimerAlertOr(
    context: context,
    or: () => _showSendAction(context),
  );
}

void _showSendAction(BuildContext context) {
  final showSearch = showSendCurrencySearch(context);

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
    children: [const _ActionSend()],
    then: (value) {
      sAnalytics.sendChooseAssetClose();
    },
  );
}

class _ActionSend extends StatelessObserverWidget {
  const _ActionSend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final state = getIt.get<ActionSearchStore>();

    return Column(
      children: [
        for (final currency in state.filteredCurrencies)
          if (currency.isAssetBalanceNotEmpty)
            if (currency.supportsCryptoWithdrawal)
              SWalletItem(
                decline: currency.dayPercentChange.isNegative,
                icon: SNetworkSvg24(
                  url: currency.iconUrl,
                ),
                primaryText: currency.description,
                removeDivider: currency == state.filteredCurrencies.last,
                amount: currency.volumeBaseBalance(baseCurrency),
                secondaryText: currency.volumeAssetBalance,
                onTap: () {
                  sAnalytics.sendToView();
                  showSendOptions(context, currency);
                },
              ),
      ],
    );
  }
}
