import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/services/signal_r/model/earn_offers_model.dart';

part 'earn_offers_state.freezed.dart';

@freezed
class EarnOffersState with _$EarnOffersState {
  const factory EarnOffersState({
    required List<EarnOfferModel> earnOffers,
  }) = _EarnOffersState;
}
