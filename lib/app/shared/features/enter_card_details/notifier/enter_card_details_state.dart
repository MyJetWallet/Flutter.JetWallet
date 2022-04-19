import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

part 'enter_card_details_state.freezed.dart';

@freezed
class EnterCardDetailsState with _$EnterCardDetailsState {
  const factory EnterCardDetailsState({
    StackLoaderNotifier? loader,
    int? month,
    int? year,
    SPhoneNumber? selectedCountry,
    @Default('') String countrySearch,
    @Default([]) List<SPhoneNumber> filteredCountries,
    @Default('') String cardNumber,
    @Default('') String cvv,
    @Default('') String cardName,
    @Default('') String cardholderName,
    @Default('') String streetAddress1,
    @Default('') String streetAddress2,
    @Default('') String city,
    @Default('') String district,
    @Default('') String postalCode,
  }) = _EnterCardDetailsState;
}
