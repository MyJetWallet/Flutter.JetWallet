import 'package:flutter/cupertino.dart';
import 'package:simple_kit/simple_kit.dart';

import 'components/earn_body.dart';
import 'components/earn_pinned.dart';

void earnBottomSheet(BuildContext context) {
  sShowBasicModalBottomSheet(
    context: context,
    removePinnedPadding: true,
    removeBottomSheetBar: true,
    removeBarPadding: true,
    horizontalPinnedPadding: 0,
    scrollable: true,
    pinned: const EarnPinned(),
    children: [
      const EarnBody(),
    ],
  );
}
