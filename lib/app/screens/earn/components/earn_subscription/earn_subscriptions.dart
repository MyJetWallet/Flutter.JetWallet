import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/earn_offers_model.dart';
import '../../../../shared/models/currency_model.dart';
import 'components/earn_subscription_pinned.dart';
import 'components/subscriptions_item.dart';

void showSubscriptionBottomSheet({
  required BuildContext context,
  required List<EarnOfferModel> offers,
  required CurrencyModel currency,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    removePinnedPadding: true,
    removeBarPadding: true,
    pinned: EarnSubscriptionPinned(name: currency.description),
    horizontalPinnedPadding: 0,
    scrollable: true,
    children: [
      SPaddingH24(
        child: Column(
          children: [
            const SpaceH15(),
            for (final element in offers) ...[
              SubscriptionsItem(
                earnOffer: element,
                currency: currency,
                apy: element.currentApy,
                isHot: element.offerTag == 'Hot',
                days: element.endDate == null
                    ? 0
                    : calcDifference(
                        firstDate: element.startDate,
                        lastDate: element.endDate!,
                      ),
              ),
            ],
            const SpaceH35(),
          ],
        ),
      ),
    ],
  );
}

int calcDifference({
  required String firstDate,
  required String lastDate,
}) {
  final firstDateTime = DateTime.parse(firstDate).toLocal();
  final lastDateTime = DateTime.parse(lastDate).toLocal();
  final difference = lastDateTime.difference(firstDateTime).inDays;
  return difference;
}
