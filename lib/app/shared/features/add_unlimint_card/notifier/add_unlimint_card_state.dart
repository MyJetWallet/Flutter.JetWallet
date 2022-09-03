import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

part 'add_unlimint_card_state.freezed.dart';

@freezed
class AddUnlimintCardState with _$AddUnlimintCardState {
  const factory AddUnlimintCardState({
    StackLoaderNotifier? loader,
    int? month,
    int? year,
    StandardFieldErrorNotifier? cardNumberError,
    StandardFieldErrorNotifier? expiryMonthError,
    StandardFieldErrorNotifier? expiryYearError,
    StandardFieldErrorNotifier? cvvError,
    @Default('') String expiryMonth,
    @Default('') String expiryYear,
    @Default('') String cardNumber,
    @Default('') String cardholderName,
    @Default(false) bool saveCard,
  }) = _AddUnlimintCardState;

  const AddUnlimintCardState._();

  bool get isCardNumberValid {
    return CreditCardValidator().validateCCNum(cardNumber).isValid;
  }

  bool get isExpiryMonthValid {
    if (int.parse(expiryMonth) > 12) return false;
    if (expiryYear.length < 4) return true;
    return CreditCardValidator()
        .validateExpDate('$expiryMonth/${expiryYear[2]}${expiryYear[3]}')
        .isValid;
  }

  bool get isExpiryYearValid {
    return CreditCardValidator()
      .validateExpDate('$expiryMonth/${expiryYear[2]}${expiryYear[3]}')
      .isValid;
  }

  bool get isCardholderNameValid {
    return cardholderName.split(' ').length >= 2;
  }

  bool get isCardDetailsValid {
    if (expiryYear.length < 4 || expiryMonth.length < 2) return false;
    return isCardNumberValid &&
        isExpiryMonthValid &&
        isExpiryYearValid &&
        isCardholderNameValid;
  }
}
