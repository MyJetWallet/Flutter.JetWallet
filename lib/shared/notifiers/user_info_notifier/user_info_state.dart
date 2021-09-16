import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info_state.freezed.dart';

@freezed
class UserInfoState with _$UserInfoState {
  const factory UserInfoState({
    @Default(false) bool pinEnabled,
  }) = _UserInfoState;
}
