import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/models/currency_model.dart';
import '../../../../../../market/view/components/fade_on_scroll.dart';
import 'components/earn_body.dart';
import 'components/earn_bottom_sheet_container.dart';
import 'components/earn_pinned.dart';
import 'components/earn_pinned_small.dart';

void showStartEarnBottomSheet({
  required BuildContext context,
  required Function(CurrencyModel) onTap,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return EarnBottomSheetContainer(
        removePinnedPadding: true,
        horizontalPinnedPadding: 0,
        scrollable: true,
        color: Colors.white,
        pinned: const EarnPinned(),
        pinnedSmall: const EarnPinnedSmall(),
        children: [
          EarnBody(
            onTap: onTap,
          ),
        ],
      );
    },
  );
}
