import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../simple_kit.dart';

Future showNotification(
  BuildContext context,
  String message, [
  int duration = 2,
  bool needFeedback = false,
  bool isError = true,
  bool hideIcon = false,
]) {
  if (needFeedback) {
    HapticFeedback.lightImpact();
  }

  return showFlash(
    context: context,
    duration: Duration(seconds: duration),
    persistent: true,
    builder: (_, controller) {
      return Flash(
        controller: controller,
        position: FlashPosition.top,
        child: SPaddingH24(
          child: SNotificationBox(
            text: message,
            isError: isError,
            hideIcon: hideIcon,
          ),
        ),
      );
    },
  );
}
