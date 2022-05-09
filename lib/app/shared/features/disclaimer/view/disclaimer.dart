import 'package:flutter/material.dart';

void showsDisclaimer({
  required Widget child,
  required BuildContext context,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return child;
    },
  );
}
