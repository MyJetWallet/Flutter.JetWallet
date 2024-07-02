import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

Future<void> showUnfinishedOperationPopUp({
  required BuildContext context,
  required String assetSunbol,
}) async {
  sAnalytics.ptpBuyPopupUnfinishedOperationScreenView(asset: assetSunbol);
  await sShowAlertPopup(
    context,
    primaryText: intl.p2p_buy_unfinished_operation,
    secondaryText: intl.p2p_buy_you_have_unfinished,
    primaryButtonName: intl.prepaid_card_continue,
    secondaryButtonName: intl.profileDetails_cancel,
    textAlign: TextAlign.left,
    image: Image.asset(
      infoLightAsset,
      width: 80,
      height: 80,
      package: 'simple_kit',
    ),
    onPrimaryButtonTap: () async {
      sAnalytics.tapOnTheButtonContinueOnPTPBuyPopup(asset: assetSunbol);
      await sRouter.push(
        TransactionHistoryRouter(
          initialIndex: 1,
        ),
      );
    },
    onSecondaryButtonTap: () {
      Navigator.pop(context);
    },
  );
}
