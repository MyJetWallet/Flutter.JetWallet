import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/earn_offers_model.dart';

import 'earn_offers_spod.dart';

final earnOffersPod = Provider.autoDispose<List<EarnOfferModel>>((ref) {
  final recurringBuys = ref.watch(earnOffersSpod);
  final items = <EarnOfferModel>[];

  recurringBuys.whenData((data) {
    for (final element in data.earnOffers) {
      items.add(element);
    }
  });

  return items;
},
  name: 'earnOffersPod',
);
