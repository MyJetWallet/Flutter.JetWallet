import 'dart:io';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showWalletRedirectingPopup(BuildContext context) {
  final isIos = Platform.isIOS;

  return sShowAlertPopup(
    context,
    image: Assets.svg.brand.small.infoBlue.simpleSvg(
      height: 80.0,
      width: 80.0,
    ),
    primaryText: intl.wallets_redirecting,
    secondaryText: intl.wallets_modal_info(
      isIos ? intl.wallets_add_to_apple_wallet : intl.wallets_add_to_google_wallet,
    ),
    textAlign: TextAlign.start,
    primaryButtonName: intl.wallets_continue,
    onPrimaryButtonTap: () async {
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
}
