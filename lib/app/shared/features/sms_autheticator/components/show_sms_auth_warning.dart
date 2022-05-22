import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/features/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import '../../../../../shared/features/two_fa_phone/view/two_fa_phone.dart';
import '../../../../../shared/providers/service_providers.dart';

void showSmsAuthWarning(BuildContext context) {
  final intl = context.read(intlPod);

  sShowAlertPopup(
    context,
    primaryText: '${intl.showSmsAuthWarning_primaryText}?',
    primaryButtonName: intl.showSmsAuthWarning_continue,
    onPrimaryButtonTap: () {
      TwoFaPhone.pushReplacement(
        context,
        const Security(
          fromDialog: true,
        ),
      );
    },
    secondaryText: '${intl.showSmsAuthWarning_secondaryText}.',
    secondaryButtonName: intl.showSmsAuthWarning_later,
    onSecondaryButtonTap: () {
      Navigator.pop(context);
    },
  );
}
