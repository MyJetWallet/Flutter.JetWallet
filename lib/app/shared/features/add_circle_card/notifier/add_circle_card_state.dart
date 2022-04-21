import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

part 'add_circle_card_state.freezed.dart';

@freezed
class AddCircleCardState with _$AddCircleCardState {
  const factory AddCircleCardState({
    StackLoaderNotifier? loader,
    int? month,
    int? year,
    SPhoneNumber? selectedCountry,
    StandardFieldErrorNotifier? cardNumberError,
    StandardFieldErrorNotifier? expiryDateError,
    StandardFieldErrorNotifier? cvvError,
    StandardFieldErrorNotifier? streetAddress1Error,
    StandardFieldErrorNotifier? streetAddress2Error,
    StandardFieldErrorNotifier? cityError,
    StandardFieldErrorNotifier? districtError,
    StandardFieldErrorNotifier? postalCodeError,
    @Default('') String expiryDate,
    @Default('') String countrySearch,
    @Default([]) List<SPhoneNumber> filteredCountries,
    @Default('') String cardNumber,
    @Default('') String cvv,
    @Default('') String cardholderName,
    @Default('') String streetAddress1,
    @Default('') String streetAddress2,
    @Default('') String city,
    @Default('') String district,
    @Default('') String postalCode,
  }) = _AddCardDetailsState;

  const AddCircleCardState._();

  bool get isCardNumberValid {
    return CreditCardValidator().validateCCNum(cardNumber).isValid;
  }

  bool get isCvvValid {
    final result = CreditCardValidator().validateCCNum(cardNumber);
    final ccvResult = CreditCardValidator().validateCVV(cvv, result.ccType);

    return ccvResult.isValid;
  }

  bool get isExpiryDateValid {
    return CreditCardValidator().validateExpDate(expiryDate).isValid;
  }

  bool get isCardholderNameValid {
    return cardholderName.split(' ').length >= 2;
  }

  bool get isStreetAddress1Valid {
    return streetAddress1.isNotEmpty;
  }

  bool get isStreetAddress2Valid {
    if (streetAddress2.isEmpty) {
      return true;
    } else {
      return streetAddress2.isNotEmpty;
    }
  }

  bool get isCityValid {
    return city.isNotEmpty;
  }

  bool get isDistrictValid {
    return district.isNotEmpty;
  }

  bool get isPostalCodeValid {
    return postalCode.isNotEmpty;
  }

  bool get isCardDetailsValid {
    return isCardNumberValid &&
        isCvvValid &&
        isExpiryDateValid &&
        isCardholderNameValid;
  }

  bool get isBillingAddressValid {
    return isStreetAddress1Valid &&
        isStreetAddress2Valid &&
        isCityValid &&
        isDistrictValid &&
        isPostalCodeValid;
  }
}
