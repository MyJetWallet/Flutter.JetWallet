import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

void showWalletVerifyAccount(BuildContext context) {
  sShowAlertPopup(
    context,
    primaryText: '',
    secondaryText: intl.wallet_verify_your_account,
    primaryButtonName: intl.wallet_verify_account,
    image: Image.asset(
      infoLightAsset,
      width: 80,
      height: 80,
      package: 'simple_kit',
    ),
    onPrimaryButtonTap: () {
      Navigator.pop(context);
    },
    secondaryButtonName: intl.wallet_cancel,
    onSecondaryButtonTap: () {
      Navigator.pop(context);
    },
  );
}
