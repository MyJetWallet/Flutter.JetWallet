import 'package:flutter/cupertino.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/models/currency_model.dart';
import 'components/earn_body.dart';
import 'components/earn_pinned.dart';

void showStartEarnBottomSheet({
  required BuildContext context,
  required Function(CurrencyModel) onTap,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    removePinnedPadding: true,
    removeBottomSheetBar: true,
    removeBarPadding: true,
    horizontalPinnedPadding: 0,
    scrollable: true,
    pinned: const EarnPinned(),
    children: [
      EarnBody(
        onTap: onTap,
      ),
    ],
  );
}
