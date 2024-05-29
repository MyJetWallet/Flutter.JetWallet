import 'package:flutter/cupertino.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

Future<void> showCommisionExplanationBottomSheet(BuildContext context) async {
  sShowBasicModalBottomSheet(
    context: context,
    horizontalPinnedPadding: 24,
    scrollable: true,
    pinned: SBottomSheetHeader(
      name: intl.prepaid_card_commission,
    ),
    children: [
      SPaddingH24(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              intl.prepaid_cardcomission_explanation,
              maxLines: 10,
              style: STStyles.body1Medium.copyWith(color: SColorsLight().gray10),
            ),
            const SpaceH64(),
          ],
        ),
      ),
    ],
  );
}
