import 'package:freezed_annotation/freezed_annotation.dart';

import 'authorized_union.dart';

part 'startup_state.freezed.dart';

@freezed
class StartupState with _$StartupState {
  const factory StartupState({
    /// Means that at the startup of the app user login or register manually
    @Default(false) bool fromLoginRegister,
    @Default(Loading()) AuthorizedUnion authorized,
  }) = _StartupState;
}
