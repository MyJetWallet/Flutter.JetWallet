import 'package:simple_kit/simple_kit.dart';

import '../../../shared/helpers/remove_chars_from.dart';
import '../models/currency_model.dart';
import '../models/selected_percent.dart';

// This helper are used in [BUY], [SELL], [CONVERT], [WITHDRAW] flows
// Working with NumberKeyboard in [amount] mode

const specialPointCase = '0.';

bool firstZeroInputCase(String string) {
  return string.length == 1 && string == zero;
}

/// Removes cases like:
/// 1) 50.0000 -> 50
/// 2) 4.3320000 -> 4.332
String truncateZerosFromInput(String input) {
  if (input.isNotEmpty) {
    final number = double.parse(input);

    if (number == 0) {
      return zero;
    }
    // if number is the whole
    else if (number % 1 == 0) {
      return number.toInt().toString();
    } else {
      return number.toString();
    }
  }

  return input;
}

String valueBasedOnSelectedPercent({
  required SelectedPercent selected,
  required CurrencyModel currency,
}) {
  if (currency.isAssetBalanceEmpty) {
    return zero;
  } else if (selected == SelectedPercent.pct25) {
    final value = currency.assetBalance * 0.25;
    return '$value';
  } else if (selected == SelectedPercent.pct50) {
    final value = currency.assetBalance * 0.50;
    return '$value';
  } else if (selected == SelectedPercent.pct100) {
    final value = currency.assetBalance;
    return '$value';
  } else {
    return zero;
  }
}

/// Function is processing the input from [NumberKeyboard] \
/// Expects single char
String responseOnInputAction({
  required String oldInput,
  required String newInput,
  required int accuracy,
}) {
  if (newInput == backspace) {
    if (oldInput.length > 1) {
      return removeCharsFrom(oldInput, 1);
    } else {
      return zero;
    }
  } else if (firstZeroInputCase(oldInput) && newInput != period) {
    return newInput;
  } else if (oldInput.isEmpty && newInput == period) {
    return specialPointCase;
  } else if (newInput == period) {
    if (oldInput.contains(period)) {
      return oldInput;
    }
  } else if (numberOfCharsAfterDecimal(oldInput) >= accuracy) {
    return oldInput;
  }

  return oldInput + newInput;
}

int numberOfCharsAfterDecimal(String string) {
  var numbersAfterDecimal = 0;
  var startCount = false;

  for (final char in string.split('')) {
    if (startCount) numbersAfterDecimal++;
    if (char == period) startCount = true;
  }

  return numbersAfterDecimal;
}

String valueAccordingToAccuracy(String value, int accuracy) {
  final chars = numberOfCharsAfterDecimal(value);

  if (chars > accuracy) {
    final difference = chars - accuracy;

    return removeCharsFrom(value, difference);
  }

  return value;
}

bool isInputValid(String input) {
  if (input.isNotEmpty) {
    final value = double.parse(input);

    if (value == 0) {
      return false;
    } else {
      return true;
    }
  }

  return false;
}

enum InputError {
  none,
  notEnoughFunds,
  enterHigherAmount,
}

extension InputErrorValue on InputError {
  String get value {
    if (this == InputError.notEnoughFunds) {
      return 'Not enough funds';
    } else if (this == InputError.enterHigherAmount) {
      return 'Enter a higher amount';
    } else {
      return 'None';
    }
  }

  bool get isActive => this != InputError.none;
}

InputError onTradeInputErrorHandler(
  String input,
  CurrencyModel currency, {
  bool addressIsInternal = false,
}) {
  if (input.isNotEmpty) {
    final value = double.parse(input);

    if (currency.assetBalance < value) {
      return InputError.notEnoughFunds;
    }
  }

  return InputError.none;
}

InputError onWithdrawInputErrorHandler(
  String input,
  CurrencyModel currency, {
  bool addressIsInternal = false,
}) {
  if (input.isNotEmpty) {
    final value = double.parse(input);

    if (currency.assetBalance < value) {
      return InputError.notEnoughFunds;
    } else if (currency.withdrawalFeeSize >= value) {
      if (addressIsInternal) {
        return InputError.none;
      } else {
        return InputError.enterHigherAmount;
      }
    }
  }

  return InputError.none;
}
