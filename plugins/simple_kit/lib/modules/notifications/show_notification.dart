import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../simple_kit.dart';

Future showNotification(
  BuildContext context,
  String message, [
  bool needFeedback = false,
  bool isError = true,
]) {
  if (needFeedback) {
    HapticFeedback.lightImpact();
  }

  return showFlash(
    context: context,
    duration: const Duration(seconds: 4),
    persistent: true,
    builder: (_, controller) {
      return Flash(
        controller: controller,
        position: FlashPosition.top,
        dismissDirections: FlashDismissDirection.values,
        child: SPaddingH24(
          child: SNotificationBox(
            text: message,
            isError: isError,
          ),
        ),
      );
    },
  );
}
