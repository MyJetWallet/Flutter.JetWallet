import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/signal_r/model/earn_offers_model.dart';
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
}
