import 'package:freezed_annotation/freezed_annotation.dart';
import '../model/kyc_operation_status_model.dart';

part 'kyc_step_state.freezed.dart';

@freezed
class KycStepState with _$KycStepState {
  const factory KycStepState({
    @Default([]) List<ModifyRequiredVerified> requiredVerified,
  }) = _KycStepState;
}

class ModifyRequiredVerified {
  ModifyRequiredVerified({
    this.verifiedDone = false,
    this.requiredVerified,
  });

  final RequiredVerified? requiredVerified;
  final bool verifiedDone;
}
