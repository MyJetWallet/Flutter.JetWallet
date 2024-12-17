import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_analytics/simple_analytics.dart';

Future<void> showFreezeCryptoCardPopup({
  required BuildContext context,
  required Function() onFreezePressed,
}) {
  sAnalytics.viewFreezeCardDialog();
  return sShowAlertPopup(
    context,
    image: Assets.svg.brand.small.infoBlue.simpleSvg(
      height: 80.0,
      width: 80.0,
    ),
    primaryText: intl.crypto_card_freeze_title,
    secondaryText: intl.crypto_card_freeze_description,
    primaryButtonName: intl.crypto_card_freeze,
    onPrimaryButtonTap: () {
      sAnalytics.tapFreezeCardButton();
      onFreezePressed();
      Navigator.pop(context);
    },
    isNeedCancelButton: true,
    cancelText: intl.crypto_card_cancel,
    onCancelButtonTap: () async {
      sAnalytics.tapCancelFreezeButton();
      Navigator.pop(context);
    },
  );
}
