import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

Future<void> showFreezeCryptoCardPopup({
  required BuildContext context,
  required Function() onFreezePressed,
}) {
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
      onFreezePressed();
      Navigator.pop(context);
    },
    isNeedCancelButton: true,
    cancelText: intl.crypto_card_cancel,
    onCancelButtonTap: () async {
      Navigator.pop(context);
    },
  );
}