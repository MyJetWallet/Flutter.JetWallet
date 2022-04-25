import 'package:freezed_annotation/freezed_annotation.dart';

import '../model/disclaimer_model.dart';

part 'disclaimer_state.freezed.dart';

@freezed
class DisclaimerState with _$DisclaimerState {
  const factory DisclaimerState({
    List<DisclaimerModel>? disclaimers,
  }) = _DisclaimerState;
}
