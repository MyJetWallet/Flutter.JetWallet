import 'package:freezed_annotation/freezed_annotation.dart';
import '../model/kyc_operation_status_model.dart';

part 'kyc_steps_state.freezed.dart';

@freezed
class KycStepsState with _$KycStepsState {
  const factory KycStepsState({
    @Default([]) List<ModifyRequiredVerified> requiredVerifications,
  }) = _KycStepsState;

  const KycStepsState._();
}

@freezed
class ModifyRequiredVerified with _$ModifyRequiredVerified {
  const factory ModifyRequiredVerified({
    RequiredVerified? requiredVerified,
    @Default(false) bool verifiedDone,
  }) = _ModifyRequiredVerified;
}
