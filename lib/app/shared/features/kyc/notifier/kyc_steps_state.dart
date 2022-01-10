import 'package:freezed_annotation/freezed_annotation.dart';
import '../model/kyc_operation_status_model.dart';

part 'kyc_steps_state.freezed.dart';

@freezed
class KycStepsState with _$KycStepsState {
  const factory KycStepsState({
    @Default([]) List<RequiredVerified> requiredVerifications,
  }) = _KycStepsState;
}
