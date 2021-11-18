import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

part 'phone_number_state.freezed.dart';

@freezed
class PhoneNumberState with _$PhoneNumberState {
  const factory PhoneNumberState({
    @Default(false) bool valid,
    String? phoneNumber,
    @Default('') String? countryName,
    @Default('') String? countryCode,
    @Default('') String? numCode,
    @Default('') String? asset,
    @Default([]) List<SPhoneNumber> filteredCountriesCode,
  }) = _PhoneNumberState;

  const PhoneNumberState._();
}
