import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/shared/simple_show_alert_popup.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class WalletsButton extends StatelessWidget {
  const WalletsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: 32,
      ),
      //! Alex S. add icon to the button
      //! Add translations
      child: SButton.black(
        callback: () {
          sShowAlertPopup(
            context,
            primaryText: intl.earn_deposit_crypto_wallet,
            secondaryText: 'secondaty text',
            primaryButtonName: 'primaryButtonName',
            image: Image.asset(
              blockedAsset,
              width: 80,
              height: 80,
              package: 'simple_kit',
            ),
            onPrimaryButtonTap: () {
              //
            },
          );
        },
        text: intl.wallets_add_to_wallet(
          Platform.isIOS ? intl.wallets_add_to_apple_wallet : intl.wallets_add_to_google_wallet,
        ),
      ),
    );
  }
}
