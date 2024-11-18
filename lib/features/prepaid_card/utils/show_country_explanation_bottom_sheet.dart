import 'package:flutter/cupertino.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

Future<void> showCountryExplanationBottomSheet(BuildContext context) async {
  await showBasicBottomSheet(
    context: context,
    header: BasicBottomSheetHeaderWidget(
      title: intl.prepaid_card_country,
    ),
    children: [
      SPaddingH24(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              intl.prepaid_card_country_explanation,
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
