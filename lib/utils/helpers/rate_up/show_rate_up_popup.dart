import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:simple_kit/simple_kit.dart';
import 'dart:io' show Platform;

Future<void> shopRateUpPopup(
  BuildContext context, {
  bool force = false,
}) async {
  final storageService = sLocalStorageService;
  var rCount = 1;

  if (!force) {
    final status = await storageService.getValue(showRateUp);
    if (status != null) {
      return;
    }

    final rateCount = await storageService.getValue(rateUpCount);

    rCount = rateCount == null ? 0 : int.tryParse(rateCount) ?? 1;

    rCount++;
    await storageService.setString(rateUpCount, rCount.toString());
  }

  if (rCount == 1 || rCount == 5 || rCount == 10) {
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
        Navigator.pop(context);
        await storageService.setString(showRateUp, 'true');

        if (Platform.isIOS) {
          await inAppReview.openStoreListing(appStoreId: '1604368566');
        } else {
          if (await inAppReview.isAvailable()) {
            await inAppReview.requestReview();
          }
        }
      },
      onCancelButtonTap: () {
        Navigator.pop(context);
      },
    );
  }
}
