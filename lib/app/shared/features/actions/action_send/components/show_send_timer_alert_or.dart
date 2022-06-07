import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/client_detail_model.dart';
import 'package:simple_networking/shared/helpers/timespan_to_duration.dart';

import '../../../../../../shared/providers/service_providers.dart';
import '../../../../providers/client_detail_pod/client_detail_pod.dart';

void showSendTimerAlertOr({
  required BuildContext context,
  required void Function() or,
}) {
  final clientDetail = context.read(clientDetailPod);

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
