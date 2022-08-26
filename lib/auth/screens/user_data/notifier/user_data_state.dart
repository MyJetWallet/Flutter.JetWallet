import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

part 'user_data_state.freezed.dart';

@freezed
class UserDataState with _$UserDataState {
  const factory UserDataState({
    @Default('') String firstName,
    StandardFieldErrorNotifier? firstNameError,
    @Default('') String lastName,
    StandardFieldErrorNotifier? lastNameError,
    @Default('') String birthDate,
    StandardFieldErrorNotifier? birthDateError,
    @Default('') String country,
    @Default('') String promoCode,
    @Default(false) bool activeButton,
  }) = _UserDataState;
}
