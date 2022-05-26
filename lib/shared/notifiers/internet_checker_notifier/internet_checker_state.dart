import 'package:freezed_annotation/freezed_annotation.dart';

part 'internet_checker_state.freezed.dart';

@freezed
class InternetCheckerState with _$InternetCheckerState {
  factory InternetCheckerState({
    @Default(false) bool internetAvailable,
  }) = _InternetCheckerState;
}
