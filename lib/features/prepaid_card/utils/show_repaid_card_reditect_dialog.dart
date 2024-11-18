import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showPrepaidCardRedirectDialog({
  required BuildContext context,
}) async {
  await sShowAlertPopup(
    context,
    primaryText: intl.prepaid_card_redirecting,
    secondaryText: intl.prepaid_card_popup_description,
    primaryButtonName: intl.prepaid_card_continue,
    secondaryButtonName: intl.prepaid_card_cancel,
    textAlign: TextAlign.start,
    image: Image.asset(
      infoLightAsset,
      width: 80,
      height: 80,
      package: 'simple_kit',
    ),
    onPrimaryButtonTap: () {
      launchURL(
        context,
        prepaidCardPartnerLink,
        launchMode: LaunchMode.externalApplication,
      );
    },
    onSecondaryButtonTap: () {
      sRouter.maybePop();
    },
  );
}
