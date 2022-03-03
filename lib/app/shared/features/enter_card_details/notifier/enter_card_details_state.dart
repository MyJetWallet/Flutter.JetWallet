import 'package:freezed_annotation/freezed_annotation.dart';

part 'enter_card_details_state.freezed.dart';

@freezed
class EnterCardDetailsState with _$EnterCardDetailsState {
  const factory EnterCardDetailsState({
    @Default('') String cardNumber,
    @Default('') String cvv,
    @Default('') String cardName,
    @Default('') String cardholderName,
    @Default('') String streetAddress1,
    @Default('') String streetAddress2,
    @Default('') String city,
    @Default('') String district,
    @Default('') String postalCode,
    @Default('') String country,
  }) = _EnterCardDetailsState;
}
