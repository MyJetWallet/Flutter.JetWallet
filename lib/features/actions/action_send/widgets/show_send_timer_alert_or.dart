import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/timespan_to_duration.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

void showSendTimerAlertOr({
  required BuildContext context,
  required void Function() or,
  required BlockingType from,
}) {
  final clientDetail = sSignalRModules.clientDetail;

  if (clientDetail.clientBlockers.isEmpty) {
    return or();
  } else {
    final ind = clientDetail.clientBlockers
        .indexWhere((element) => element.blockingType == from);

    if (ind != -1) {
      return _showTimerAlert(
        context,
        clientDetail,
        clientDetail.clientBlockers[ind].expireDateTime ?? DateTime.now(),
        from,
      );
    }

    return or();
/*
    for (final blocker in clientDetail.clientBlockers) {
      if (blocker.blockingType == BlockingType.transfer) {
        return _showTimerAlert(
          context,
          clientDetail,
          blocker.expireDateTime ?? DateTime.now(),
        );
      } else if (blocker.blockingType == BlockingType.withdrawal) {
        return _showTimerAlert(
          context,
          clientDetail,
          blocker.expireDateTime ?? DateTime.now(),
        );
      } else if (blocker.blockingType == BlockingType.trade) {
        return _showTimerAlert(
          context,
          clientDetail,
          blocker.expireDateTime ?? DateTime.now(),
        );
      }
    }

    return or();
    */
  }
}

void _showTimerAlert(
  BuildContext context,
  ClientDetailModel clientDetail,
  DateTime expireIn,
  BlockingType from,
) {
  final expireFormatted = DateFormat('d MMM y H:m').format(expireIn);

  String getDescription() {
    switch (from) {
      case BlockingType.deposit:
        return intl.deposit_timer_alert_description;
      case BlockingType.withdrawal:
        return intl.send_timer_alert_description;
      case BlockingType.trade:
        return intl.trade_timer_alert_description;
      default:
        return intl.send_timer_alert_description;
    }
  }

  if (!DateTime.now().isAfter(expireIn)) {
    sShowTimerAlertPopup(
      context: context,
      buttonName: intl.send_timer_alert_ok,
      description: getDescription(),
      expireIn: expireFormatted,
      onButtonTap: () => Navigator.pop(context),
    );
  }
}
