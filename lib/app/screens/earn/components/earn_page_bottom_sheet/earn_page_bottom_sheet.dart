import 'package:flutter/cupertino.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/models/currency_model.dart';
import 'components/earn_page_body.dart';
import 'components/earn_page_pinned.dart';

void showStartEarnPageBottomSheet({
  required BuildContext context,
  required Function(CurrencyModel) onTap,
}) {
  sAnalytics.earnOnBoardingView();
  sShowBasicModalBottomSheet(
    context: context,
    removePinnedPadding: true,
    removeBottomSheetBar: true,
    removeBarPadding: true,
    pinned: const EarnPagePinned(),
    horizontalPinnedPadding: 0,
    scrollable: true,
    onDissmis: () => sAnalytics.earnCloseOnboarding(),
    children: [
      const EarnPageBody(),
    ],
  );
}
