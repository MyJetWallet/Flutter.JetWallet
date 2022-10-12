import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

void showTransactionFeeBottomSheet({
  required BuildContext context,
  required SimpleColors colors,
  bool isAbsolute = false,
  String? tradeFeeAbsolute,
  Decimal? tradeFeePercentage,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    removePinnedPadding: true,
    pinned: SPaddingH24(
      child: SBottomSheetHeader(
        name: intl.previewBuyWithUnlimint_transactionFee,
      ),
    ),
    horizontalPinnedPadding: 0,
    scrollable: true,
    children: [
      const SpaceH24(),
      SPaddingH24(
        child: Column(
          children: [
            SActionConfirmText(
              name: intl.previewBuyWithUnlimint_thirdFee,
              value: isAbsolute
                  ? tradeFeeAbsolute ?? ''
                  : '${intl.previewBuyWithUnlimint_from} $tradeFeePercentage%',
            ),
            const SpaceH32(),
            const SDivider(),
            const SpaceH25(),
            Text(
              intl.previewBuyWithUnlimint_feeDescription,
              style: sBodyText2Style.copyWith(
                color: colors.grey1,
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      const SpaceH60(),
    ],
  );
}
