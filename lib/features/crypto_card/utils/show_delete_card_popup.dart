import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

/// Returns true if the "Confirm and delete" button is pressed
Future<bool?> showDeleteCardPopUp({
  required BuildContext context,
  required String cardLast4,
}) async {
  final result = await sShowAlertPopup(
    context,
    image: Assets.svg.brand.small.error.simpleSvg(
      height: 80,
      width: 80,
    ),
    primaryText: intl.crypto_card_delete_card,
    secondaryText: intl.crypto_card_delete_description(cardLast4),
    isPrimaryButtonRed: true,
    primaryButtonName: intl.crypto_card_delete_confirm,
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
