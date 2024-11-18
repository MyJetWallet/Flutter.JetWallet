import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_kit_updated/widgets/banner/toast/simple_notification_box.dart';


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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: SNotificationBox(
            text: message,
            isError: isError,
          ),
        ),
      );
    },
  );
}
