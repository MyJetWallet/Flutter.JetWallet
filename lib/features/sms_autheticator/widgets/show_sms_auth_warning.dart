import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import 'package:simple_kit/simple_kit.dart';

void showSmsAuthWarning(BuildContext context) {
  sShowAlertPopup(
    context,
    primaryText: '${intl.showSmsAuthWarning_primaryText}?',
    primaryButtonName: intl.showSmsAuthWarning_continue,
    onPrimaryButtonTap: () {
      Navigator.pop(context);
      sRouter.push(
        TwoFaPhoneRouter(
          trigger: const Security(
            fromDialog: true,
          ),
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
