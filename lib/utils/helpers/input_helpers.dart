import 'package:decimal/decimal.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';

import '../models/currency_model.dart';
import '../models/selected_percent.dart';

// These helpers are used in [BUY], [SELL], [CONVERT], [WITHDRAW] flows
// Working with NumberKeyboard in [amount] mode

const specialPointCase = '0.';

bool firstZeroInputCase(String string) {
  return string.length == 1 && string == zero;
}

String valueBasedOnSelectedPercent({
  Decimal? availableBalance,
  required SelectedPercent selected,
  required CurrencyModel currency,
}) {
  if (selected == SelectedPercent.pct25) {
    final value = (availableBalance ?? currency.assetBalance) * Decimal.parse('0.25');

    return '$value';
  } else if (selected == SelectedPercent.pct50) {
    final value = (availableBalance ?? currency.assetBalance) * Decimal.parse('0.50');

    return '$value';
  } else if (selected == SelectedPercent.pct100) {
    final value = availableBalance ?? currency.assetBalance;

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
  int wholePartLenght = 15,
}) {
  if (newInput == backspace) {
    return oldInput.length > 1 ? removeCharsFrom(oldInput, 1) : zero;
  } else if (firstZeroInputCase(oldInput) && newInput != period) {
    return newInput;
  } else if (oldInput.isEmpty && newInput == period) {
    return specialPointCase;
  } else if (newInput == period) {
    if (oldInput.contains(period) || accuracy == 0) {
      return oldInput;
    }
  } else if (!oldInput.contains(period) && oldInput.length >= wholePartLenght) {
    return oldInput;
  } else if (numberOfCharsAfterDecimal(oldInput) >= accuracy) {
    if (accuracy != 0) {
      return oldInput;
    }
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

    return value != 0;
  }

  return false;
}

enum InputError {
  none,
  notEnoughFunds,
  enterHigherAmount,
  amountTooLarge,
  amountTooLow,
  limitError,
}

extension InputErrorValue on InputError {
  String value({String errorInfo = ''}) {
    if (this == InputError.notEnoughFunds) {
      return intl.input_error_insufficient_balance;
    } else if (this == InputError.enterHigherAmount) {
      return intl.input_error_higher_amount;
    } else if (this == InputError.amountTooLarge) {
      return '${intl.input_error_smaller_amount} $errorInfo';
    } else if (this == InputError.amountTooLow) {
      return '${intl.input_error_higher_amount}. $errorInfo';
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
  Decimal? availableBalance,
}) {
  if (input.isNotEmpty) {
    final value = Decimal.parse(input);

    if ((availableBalance ?? currency.assetBalance) < value) {
      return InputError.notEnoughFunds;
    }
  }

  return InputError.none;
}

InputError onWithdrawInputErrorHandler(
  String input,
  String network,
  CurrencyModel currency, {
  bool addressIsInternal = false,
}) {
  if (input.isNotEmpty) {
    final value = Decimal.parse(input);

    if (currency.assetBalance < value) {
      return InputError.notEnoughFunds;
    } else if (currency.withdrawalFeeSize(network) >= value) {
      return addressIsInternal ? InputError.none : InputError.enterHigherAmount;
    }
  }

  return InputError.none;
}

InputError onGloballyWithdrawInputErrorHandler(
  String input,
  CurrencyModel currency,
  CardLimitsModel? limits,
) {
  if (input.isNotEmpty) {
    final value = Decimal.parse(input);

    if (currency.assetBalance < value) {
      return InputError.notEnoughFunds;
    }
  }

  return InputError.none;
}

InputError onEurWithdrawInputErrorHandler(
  String input,
  Decimal balance,
  CardLimitsModel? limits,
) {
  if (input.isNotEmpty) {
    final value = Decimal.parse(input);

    if (balance < value) {
      return InputError.notEnoughFunds;
    }
  }

  return InputError.none;
}
