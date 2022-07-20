import 'package:flutter/cupertino.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/card_limits_model.dart';

import 'limit_page_body.dart';

void showCardLimitsBottomSheet({
  required BuildContext context,
  required CardLimitsModel cardLimits,
}) {
  sAnalytics.earnOnBoardingView();
  sShowBasicModalBottomSheet(
    context: context,
    removePinnedPadding: true,
    removeBottomSheetBar: true,
    removeBarPadding: true,
    horizontalPinnedPadding: 0,
    scrollable: true,
    children: [
      LimitPageBody(cardLimit: cardLimits),
    ],
  );
}
