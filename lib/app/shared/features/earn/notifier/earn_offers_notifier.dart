import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/earn_offers_model.dart';

import 'earn_offers_state.dart';

class EarnOffersNotifier extends StateNotifier<EarnOffersState> {
  EarnOffersNotifier(
    this.read,
    this.earnOffers,
  ) : super(
          const EarnOffersState(
            earnOffers: <EarnOfferModel>[],
          ),
        ) {
    _init();
  }

  final Reader read;
  final List<EarnOfferModel> earnOffers;

  void _init() {
    earnOffers.sort((a, b) => a.currentApy.compareTo(b.currentApy));
    state = state.copyWith(earnOffers: [...earnOffers]);
  }

  bool isActiveState(List<EarnOfferModel> array) {
    var isActive = false;
    for (final element in array) {
      if (element.amount > Decimal.zero) {
        isActive = true;
      }
    }
    return isActive;
  }

  int getActiveLength(List<EarnOfferModel> array) {
    return array.map((e) => e.amount > Decimal.zero).toList().length;
  }
}
