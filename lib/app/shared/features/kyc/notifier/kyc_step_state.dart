import 'package:freezed_annotation/freezed_annotation.dart';
import 'kyc_steps_state.dart';

part 'kyc_step_state.freezed.dart';

@freezed
class KycStepState with _$KycStepState {
  const factory KycStepState({
    @Default([]) List<ModifyRequiredVerified> requiredVerified,
  }) = _KycStepState;
}


