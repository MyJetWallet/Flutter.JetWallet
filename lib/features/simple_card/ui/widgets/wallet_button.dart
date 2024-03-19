import 'dart:io';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/simple_show_alert_popup.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletsButton extends StatelessWidget {
  const WalletsButton({
    required this.cardNumber,
    required this.cardId,
    super.key,
  });
  final String cardNumber;
  final String cardId;

  @override
  Widget build(BuildContext context) {
    final isIos = Platform.isIOS;

    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: 32,
      ),
      child: SButton.black(
        borderRadius: !isIos ? BorderRadius.circular(25) : null,
        icon: Image.asset(
          isIos ? 'assets/images/wallet_apple.png' : 'assets/images/wallet_google.png',
          height: isIos ?  20 : 24,
        ),
        callback: () {
          isIos
              ? sAnalytics.tapOnTheAddToAppleWalletButton(cardId: cardId)
              : sAnalytics.tapOnTheAddToGoogleWalletButton(cardId: cardId);
          sAnalytics.popupAddCardToWalletScreenView(cardId: cardId);
          sShowAlertPopup(
            context,
            textAlign: TextAlign.start,
            primaryText: intl.wallets_redirecting,
            secondaryText:
                intl.wallets_modal_info(isIos ? intl.wallets_add_to_apple_wallet : intl.wallets_add_to_google_wallet),
            primaryButtonName: intl.wallets_continue,
            image: Image.asset(
              disclaimerAsset,
              width: 80,
              height: 80,
            ),
            onPrimaryButtonTap: () async {
              sAnalytics.tapOnTheContinueAddToWalletButton(cardId: cardId);
              onCopyAction(cardNumber);
              Navigator.pop(context);

              isIos
                  ? await LaunchApp.openApp(
                      androidPackageName: 'com.google.android.apps.walletnfcrel',
                      iosUrlScheme: 'shoebox://',
                      appStoreLink: 'https://apps.apple.com/us/app/apple-wallet/id1160481993',
                    )
                  : await launchURL(
                      context,
                      'https://wallet.google.com/gw/app/addfop',
                      launchMode: LaunchMode.platformDefault,
                    );
            },
          );
        },
        text: intl.wallets_add_to_wallet(
          isIos ? intl.wallets_add_to_apple_wallet : intl.wallets_add_to_google_wallet,
        ),
      ),
    );
  }
}

void onCopyAction(String value) {
  Clipboard.setData(
    ClipboardData(
      text: value.replaceAll(' ', ''),
    ),
  );
}
