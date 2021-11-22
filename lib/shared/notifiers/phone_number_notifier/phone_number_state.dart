import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

part 'phone_number_state.freezed.dart';

@freezed
class PhoneNumberState with _$PhoneNumberState {
  const factory PhoneNumberState({
    @Default(false) bool valid,
    String? phoneNumber,
    String? countryName,
    String? countryCode,
    String? numCode,
    String? asset,
    List<SPhoneNumber> filteredCountriesCode,
  }) = _PhoneNumberState;

  const PhoneNumberState._();
}
