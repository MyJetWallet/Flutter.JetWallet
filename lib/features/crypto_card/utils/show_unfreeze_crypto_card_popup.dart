import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

Future<void> showUnfreezeCryptoCardPopup({
  required BuildContext context,
  required Function() onUnfreezePressed,
}) {
  sAnalytics.viewUnfreezeCardDialog();
  return sShowAlertPopup(
    context,
    image: Assets.svg.brand.small.infoBlue.simpleSvg(
      height: 80.0,
      width: 80.0,
    ),
    primaryText: intl.crypto_card_unfreeze_title,
    secondaryText: intl.crypto_card_unfreeze_description,
    primaryButtonName: intl.crypto_card_unfreeze,
    onPrimaryButtonTap: () {
      sAnalytics.tapUnfreezeCard();
      onUnfreezePressed();
      Navigator.pop(context);
    },
    isNeedCancelButton: true,
    cancelText: intl.crypto_card_cancel,
    onCancelButtonTap: () async {
      sAnalytics.tapCancelUnfreeze();
      Navigator.pop(context);
    },
  );
}
