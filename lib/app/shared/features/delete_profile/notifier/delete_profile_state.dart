import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/services/profile/model/profile_delete_reasons_model.dart';

part 'delete_profile_state.freezed.dart';

@freezed
class DPState with _$DPState {
  const factory DPState({
    @Default([]) List<ProfileDeleteReasonsModel> deleteReason,
    @Default([]) List<ProfileDeleteReasonsModel> selectedDeleteReason,
    @Default(false) bool confitionCheckbox,
  }) = _DPState;
}
