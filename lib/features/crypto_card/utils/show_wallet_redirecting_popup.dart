import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:logger/logger.dart';
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
      await sRouter.maybePop();

      try {
        isIos
            ? await launchUrl(
                Uri.parse('shoebox://'),
              )
            : await launchURL(
                context,
                'https://wallet.google.com/gw/app/addfop',
                launchMode: LaunchMode.platformDefault,
              );
      } catch (e) {
        getIt.get<SimpleLoggerService>().log(
              level: Level.error,
              place: 'ShowWalletRedirectingPopup',
              message: 'Error while opening wallet: $e',
            );
      }
    },
  );
}
