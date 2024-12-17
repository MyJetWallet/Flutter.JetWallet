import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';

/// Returns true if the "Verify account" button is pressed
Future<bool?> showPleaseVerifyAccountPopUp({
  required BuildContext context,
}) async {
  final result = await sShowAlertPopup(
    context,
    primaryText: '',
    secondaryText: intl.crypto_card_creat_please_verify_your_account,
    primaryButtonName: intl.crypto_card_creat_verify_account,
    onPrimaryButtonTap: () async {
      await sRouter.maybePop(true);
    },
    secondaryButtonName: intl.wallet_cancel,
    onSecondaryButtonTap: () {
      sRouter.maybePop(false);
    },
  );

  return result is bool? ? result : false;
}
