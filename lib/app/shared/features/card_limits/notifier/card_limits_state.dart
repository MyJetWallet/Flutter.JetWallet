import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/services/signal_r/model/card_limits_model.dart';

part 'card_limits_state.freezed.dart';

@freezed
class CardLimitsState with _$CardLimitsState {
  const factory CardLimitsState({
    CardLimitsModel? cardLimits,
  }) = _CardLimitsState;
}
