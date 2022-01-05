import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/features/two_fa/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import '../../../../../shared/features/two_fa/two_fa_phone/view/two_fa_phone.dart';

void showSmsAuthWarning(BuildContext context) {
  sShowAlertPopup(
    context,
    primaryText: 'Are you sure you want to disable SMS Authentication?',
    primaryButtonName: 'Continue',
    onPrimaryButtonTap: () {
      TwoFaPhone.pushReplacement(
        context,
        const Security(
          fromDialog: true,
        ),
      );
    },
    secondaryText: 'I understand and accept all risks associated with '
        'lowering the level of account security. For security reasons, '
        'the ability to withdraw funds from the account will '
        'be suspended for 24 hours.',
    secondaryButtonName: 'Later',
    onSecondaryButtonTap: () {
      Navigator.pop(context);
    },
  );
}
