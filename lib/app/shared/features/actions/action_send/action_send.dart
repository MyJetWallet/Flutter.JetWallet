import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/providers/service_providers.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../helpers/show_currency_search.dart';
import '../shared/components/action_bottom_sheet_header.dart';
import '../shared/notifier/action_search_notipod.dart';
import 'components/send_options.dart';
import 'components/show_send_timer_alert_or.dart';

void showSendAction(BuildContext context) {
  Navigator.pop(context);

  showSendTimerAlertOr(
    context: context,
    or: () => _showSendAction(context),
  );
}

void _showSendAction(BuildContext context) {
  final intl = context.read(intlPod);
  final showSearch = showSendCurrencySearch(context);

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: ActionBottomSheetHeader(
      name: intl.actionSend_bottomSheetHeaderName,
      showSearch: showSearch,
      onChanged: (String value) {
        context.read(actionSearchNotipod.notifier).search(value);
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

class _ActionSend extends HookWidget {
  const _ActionSend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);
    final state = useProvider(actionSearchNotipod);

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
                removeDivider: currency == state.sendCurrencies.last,
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
