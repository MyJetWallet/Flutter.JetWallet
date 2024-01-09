import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

Future<void> shopRateUpPopup(BuildContext context) async {
  await sShowAlertPopup(
    context,
    primaryText: intl.rate_title,
    secondaryText: intl.rate_subtitle,
    primaryButtonName: intl.rate_submit_button,
    cancelText: intl.rate_cancel_button,
    image: Image.asset(
      ratingAsset,
      width: 80,
      height: 80,
      package: 'simple_kit',
    ),
    isNeedCancelButton: true,
    onPrimaryButtonTap: () async {
      final inAppReview = InAppReview.instance;

      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      }

      Navigator.pop(context);
    },
    onCancelButtonTap: () {
      Navigator.pop(context);
    },
  );
}
