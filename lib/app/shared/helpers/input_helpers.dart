import '../../screens/market/model/currency_model.dart';
import '../components/balance_selector/model/selected_percent.dart';
import '../components/number_keyboard/number_keyboard.dart';

const specialPointCase = '0.';

bool firstZeroInputCase(String string) {
  return string.length == 1 && string == zero;
}

String removeCharsFrom(String string, int amount) {
  return string.substring(0, string.length - amount);
}

/// Removes cases like:
/// 1) 50.0000 -> 50
/// 2) 4.3320000 -> 4.332
String truncateZerosFromInput(String input) {
  if (input.isNotEmpty) {
    final number = double.parse(input);

    if (number == 0) {
      return '0';
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
    return '0';
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
    return '0';
  }
}

/// Function is processing the input from [NumberKeyboard] \
/// Expects single char
String responseOnInputAction({
  required String oldInput,
  required String newInput,
  required double accuracy,
}) {
  if (newInput == backspace) {
    if (oldInput.isNotEmpty) {
      return removeCharsFrom(oldInput, 1);
    } else {
      return oldInput;
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

String valueAccordingToAccuracy(String value, double accuracy) {
  final chars = numberOfCharsAfterDecimal(value);

  if (chars > accuracy) {
    final difference = (chars - accuracy).toInt();

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

/// Shows value of the InputField based on the input and selectedCurrency \
/// Used on [Deposit], [Sell] and [Buy] screens
String fieldValue(String input, String symbol) {
  return '${input.isEmpty ? '0' : input} $symbol';
}
