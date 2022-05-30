import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/earn_offers_model.dart';

import 'earn_offers_spod.dart';

final earnOffersPod = Provider.autoDispose<List<EarnOfferModel>>((ref) {
  final earnOffers = ref.watch(earnOffersSpod);
  final items = <EarnOfferModel>[];

  earnOffers.whenData((data) {
    for (final element in data) {
      items.add(element);
    }
  });

  return items;
},
  name: 'earnOffersPod',
);
