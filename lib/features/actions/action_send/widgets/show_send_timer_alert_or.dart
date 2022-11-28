import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/timespan_to_duration.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

void showSendTimerAlertOr({
  required BuildContext context,
  required void Function() or,
}) {
  final clientDetail = sSignalRModules.clientDetail;

  if (clientDetail.clientBlockers.isEmpty) {
    return or();
  } else {
    for (final blocker in clientDetail.clientBlockers) {
      if (blocker.blockingType == BlockingType.transfer) {
        return _showTimerAlert(context, clientDetail, blocker.timespanToExpire);
      } else if (blocker.blockingType == BlockingType.withdrawal) {
        return _showTimerAlert(context, clientDetail, blocker.timespanToExpire);
      }
    }

    return or();
  }
}

void _showTimerAlert(
  BuildContext context,
  ClientDetailModel clientDetail,
  String expireIn,
) {
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
