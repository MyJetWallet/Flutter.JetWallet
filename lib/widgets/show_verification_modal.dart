import 'package:flutter/material.dart';
import 'package:jetwallet/features/auth/verification_reg/verification_screen.dart';

void showModalVerification(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
    builder: (BuildContext context) {
      return const VerificationScreen();
    },
  );
}
