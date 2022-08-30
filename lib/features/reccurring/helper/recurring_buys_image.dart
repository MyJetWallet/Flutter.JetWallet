import 'package:flutter/cupertino.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_model.dart';

Widget recurringBuysImage(RecurringBuysStatus type) {
  switch (type) {
    case RecurringBuysStatus.active:
      return Image.asset(
        recurringBuyImage,
        height: 24,
        width: 24,
      );
    case RecurringBuysStatus.paused:
      return Image.asset(
        recurringBuyPausedImage,
        height: 24,
        width: 24,
      );
    case RecurringBuysStatus.deleted:
      return const SRecurringBuysIcon();
    case RecurringBuysStatus.empty:
      return const SRecurringBuysIcon();
  }
}
