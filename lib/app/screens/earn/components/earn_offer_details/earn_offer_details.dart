import 'package:flutter/cupertino.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/earn_offers_model.dart';
import 'components/earn_offer_details_body.dart';
import 'components/earn_offer_details_pinned.dart';

void showEarnOfferDetails({
  required BuildContext context,
  required EarnOfferModel earnOffer,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    removePinnedPadding: true,
    removeBarPadding: true,
    pinned: EarnOfferDetailsPinned(earnOffer: earnOffer),
    horizontalPinnedPadding: 0,
    scrollable: true,
    children: [
      EarnOfferDetailsBody(earnOffer: earnOffer),
    ],
  );
}
