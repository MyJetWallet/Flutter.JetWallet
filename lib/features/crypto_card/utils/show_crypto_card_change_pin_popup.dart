import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

Future<void> showCryptoCardChangePinPopup(BuildContext context) {
  return sShowAlertPopup(
    context,
    image: Assets.svg.brand.small.infoYellow.simpleSvg(
      height: 80.0,
      width: 80.0,
    ),
    primaryText: intl.crypto_card_change_your_pin,
    secondaryText: intl.crypto_card_change_your_pin_description,
    primaryButtonName: intl.crypto_card_continue,
    onPrimaryButtonTap: () {
      Navigator.pop(context);

      context.router.push(
        const CryptoCardChangePinRoute(),
      );
    },
    isNeedCancelButton: true,
    cancelText: intl.crypto_card_cancel,
    onCancelButtonTap: () {
      Navigator.pop(context);
    },
  );
}
