import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/services/disclaimer/model/disclaimers_response_model.dart';

part 'delete_profile_state.freezed.dart';

@freezed
class DPState with _$DPState {
  const factory DPState({
    @Default([]) List<String> deleteReason,
    @Default(false) bool confitionCheckbox,
  }) = _DPState;
}
