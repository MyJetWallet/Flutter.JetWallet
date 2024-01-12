import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:simple_kit/simple_kit.dart';

Future<void> shopRateUpPopup(
  BuildContext context, {
  bool force = false,
}) async {
  final storageService = sLocalStorageService;
  var rCount = 0;

  if (!force) {
    final status = await storageService.getValue(showRateUp);
    if (status != null) {
      return;
    }

    final rateCount = await storageService.getValue(rateUpCount);

    rCount = rateCount == null ? 0 : int.tryParse(rateCount) ?? 0;

    rCount++;
    await storageService.setString(rateUpCount, rCount.toString());
  }

  if (rCount == 0 || rCount == 4 || rCount == 9) {
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
          await storageService.setString(showRateUp, 'true');

          await inAppReview.requestReview();
        }

        Navigator.pop(context);
      },
      onCancelButtonTap: () {
        Navigator.pop(context);
      },
    );
  }
}
