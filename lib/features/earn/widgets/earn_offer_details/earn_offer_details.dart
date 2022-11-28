import 'package:flutter/cupertino.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';

import 'components/earn_offer_details_body.dart';
import 'components/earn_offer_details_pinned.dart';

void showEarnOfferDetails({
  required BuildContext context,
  required EarnOfferModel earnOffer,
  required String assetName,
}) {
  sAnalytics.earnActiveSheetView(
    assetName: assetName,
    amount: earnOffer.amount.toString(),
    apy: earnOffer.currentApy.toString(),
    term: earnOffer.term,
    offerId: earnOffer.offerId,
  );
  sShowBasicModalBottomSheet(
    context: context,
    removePinnedPadding: true,
    removeBarPadding: true,
    pinned: EarnOfferDetailsPinned(earnOffer: earnOffer),
    horizontalPinnedPadding: 0,
    scrollable: true,
    then: (value) {
      sAnalytics.earnCloseActiveSheet(
        assetName: assetName,
        amount: earnOffer.amount.toString(),
        apy: earnOffer.currentApy.toString(),
        term: earnOffer.term,
        offerId: earnOffer.offerId,
      );
    },
    children: [
      EarnOfferDetailsBody(earnOffer: earnOffer),
    ],
  );
}
