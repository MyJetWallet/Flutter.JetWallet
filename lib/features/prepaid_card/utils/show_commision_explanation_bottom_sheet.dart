import 'package:flutter/cupertino.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';

Future<void> showCommisionExplanationBottomSheet(BuildContext context) async {
  await showBasicBottomSheet(
    context: context,
    header: BasicBottomSheetHeaderWidget(
      title: intl.prepaid_card_commission,
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
