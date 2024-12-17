import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';

/// Returns true if the "Continue" button is pressed
Future<bool?> showUploadInternationalPassportPopup({
  required BuildContext context,
}) async {
  final result = await sShowAlertPopup(
    context,
    primaryText: intl.crypto_card_creat_upload_your_international_passport,
    secondaryText: intl.crypto_card_creat_upload_your_international_passport_description,
    primaryButtonName: intl.crypto_card_continue,
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
