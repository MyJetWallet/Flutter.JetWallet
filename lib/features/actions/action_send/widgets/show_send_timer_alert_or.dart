import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

Duration getDurationFromBlocker(String timespanToExpire) {
  var days = 0;
  var hours = 0;
  var minutes = 0;

  final parts = timespanToExpire.split('.');

  if (parts.length == 3) {
    if (parts.asMap().containsKey(0)) {
      days = int.tryParse(parts[0]) ?? 0;
    }

    if (parts.asMap().containsKey(1)) {
      final times = parts[1].split(':');

      if (times.asMap().containsKey(0)) {
        hours = int.tryParse(times[0]) ?? 0;
      }
      if (times.asMap().containsKey(1)) {
        minutes = int.tryParse(times[1]) ?? 0;
      }
    }
  } else {
    final times = timespanToExpire.split(':');

    if (times.asMap().containsKey(0)) {
      hours = int.tryParse(times[0]) ?? 0;
    }
    if (times.asMap().containsKey(1)) {
      minutes = int.tryParse(times[1]) ?? 0;
    }
  }

  return Duration(days: days, hours: hours, minutes: minutes);
}

void showSendTimerAlertOr({
  required BuildContext context,
  required void Function() or,
  required List<BlockingType> from,
}) {
  final clientDetail = sSignalRModules.clientDetail;

  if (clientDetail.clientBlockers.isEmpty) {
    return or();
  } else {
    final ind = clientDetail.clientBlockers.indexWhere(
      (element) => from.contains(element.blockingType),
    );

    return ind != -1
        ? _showTimerAlert(
            clientDetail.clientBlockers[ind].expireDateTime ??
                DateTime.now().add(
                  getDurationFromBlocker(clientDetail.clientBlockers[ind].timespanToExpire),
                ),
                from,
          )
        : or();
  }
}

void _showTimerAlert(
  DateTime expireIn,
  List<BlockingType> from,
) {
  final expireFormatted = DateFormat('d MMM y', intl.localeName).format(expireIn);

  String getDescription() {
    switch (from.first) {
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

  sNotification.showError(
    '${getDescription()} $expireFormatted',
    id: 1,
    hideIcon: true,
  );
}
