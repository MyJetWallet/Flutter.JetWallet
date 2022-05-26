import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/client_detail_model.dart';
import 'package:simple_networking/shared/helpers/timespan_to_duration.dart';

import '../../../../../shared/providers/service_providers.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../providers/client_detail_pod/client_detail_pod.dart';
import '../helpers/show_currency_search.dart';
import '../shared/components/action_bottom_sheet_header.dart';
import '../shared/notifier/action_search_notipod.dart';
import 'components/send_options.dart';

void showSendAction(BuildContext context) {
  Navigator.pop(context);

  final clientDetail = context.read(clientDetailPod);

  if (clientDetail.clientBlockers.isEmpty) {
    return _showActionSend(context);
  } else {
    for (final blocker in clientDetail.clientBlockers) {
      if (blocker.blockingType == BlockingType.transfer) {
        return _showTimerAlert(context, clientDetail, blocker.timespanToExpire);
      } else if (blocker.blockingType == BlockingType.withdrawal) {
        return _showTimerAlert(context, clientDetail, blocker.timespanToExpire);
      }
    }
    return _showActionSend(context);
  }
}

void _showActionSend(BuildContext context) {
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
  );
}

void _showTimerAlert(
  BuildContext context,
  ClientDetailModel clientDetail,
  String expireIn,
) {
  final intl = context.read(intlPod);
  final recivedAt = clientDetail.recivedAt;
  final now = DateTime.now();

  final difference = now.difference(recivedAt).inSeconds;
  final expire = timespanToDuration(expireIn).inSeconds;
  final result = expire - difference;

  if (result > 0) {
    sShowTimerAlertPopup(
      context: context,
      buttonName: intl.send_timer_alert_ok,
      description: intl.send_timer_alert_description,
      expireIn: Duration(seconds: result),
      onButtonTap: () => Navigator.pop(context),
    );
  }
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
                  showSendOptions(context, currency);
                },
              ),
      ],
    );
  }
}
