import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/earn_offers_pod.dart';
import 'earn_offers_notifier.dart';
import 'earn_offers_state.dart';

final earnOffersNotipod = StateNotifierProvider.autoDispose<
    EarnOffersNotifier, EarnOffersState>(
  (ref) {
    final earnOffers = ref.watch(earnOffersPod);

    return EarnOffersNotifier(
      ref.read,
      earnOffers,
    );
  },
);
