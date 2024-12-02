import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

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
