import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

Duration getDurationFromBlocker(String timespanToExpire) {
  var hours = 0;
  var minutes = 0;

  final times = timespanToExpire.split(':');

  if (times.asMap().containsKey(0)) {
    hours = int.tryParse(times[0]) ?? 0;
  }
  if (times.asMap().containsKey(1)) {
    minutes = int.tryParse(times[1]) ?? 0;
  }
  if (times.asMap().containsKey(2)) {
    //seconds = int.tryParse(times[2]) ?? 0;
  }

  return Duration(hours: hours, minutes: minutes);
}

void showSendTimerAlertOr({
  required BuildContext context,
  required void Function() or,
  required BlockingType from,
}) {
  final clientDetail = sSignalRModules.clientDetail;

  if (clientDetail.clientBlockers.isEmpty) {
    return or();
  } else {
    final ind = clientDetail.clientBlockers.indexWhere(
      (element) => element.blockingType == from,
    );

    return ind != -1
        ? _showTimerAlert(
            context,
            clientDetail,
            clientDetail.clientBlockers[ind].expireDateTime ??
                DateTime.now().add(
                  getDurationFromBlocker(
                    clientDetail.clientBlockers[ind].timespanToExpire,
                  ),
                ),
            from,
          )
        : or();

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
  final expireFormatted =
      DateFormat('d MMM y HH:mm', intl.localeName).format(expireIn);

  String getDescription() {
    switch (from) {
      case BlockingType.deposit:
        return intl.deposit_timer_alert_description;
      case BlockingType.withdrawal:
        return intl.send_timer_alert_description;
      case BlockingType.trade:
        return intl.trade_timer_alert_description;
      case BlockingType.phoneNumberUpdate:
        return intl.phone_update_block;
      default:
        return intl.send_timer_alert_description;
    }
  }

  sShowTimerAlertPopup(
    context: context,
    buttonName: intl.send_timer_alert_ok,
    description: getDescription(),
    expireIn: expireFormatted,
    onButtonTap: () => Navigator.pop(context),
  );
}
