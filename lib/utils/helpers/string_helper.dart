import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from_all.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

String localizedMonth(
  String month,
  BuildContext context,
) {
  switch (month) {
    case 'January':
      return intl.january;
    case 'February':
      return intl.febuary;
    case 'March':
      return intl.march;
    case 'April':
      return intl.april;
    case 'May':
      return intl.may;
    case 'June':
      return intl.june;
    case 'July':
      return intl.july;
    case 'August':
      return intl.august;
    case 'September':
      return intl.september;
    case 'October':
      return intl.october;
    case 'November':
      return intl.november;
    case 'December':
      return intl.december;
    default:
      return '';
  }
}

bool isEmailValid(String email) {
  const pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r'{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]'
      r'{0,253}[a-zA-Z0-9])?)*$';

  return RegExp(pattern).hasMatch(email);
}

bool isPasswordValid(String password) {
  return isPasswordLengthValid(password) &&
      isPasswordHasAtLeastOneLetter(password) &&
      isPasswordHasAtLeastOneNumber(password);
}

bool isPasswordLengthValid(String password) {
  return password.length >= minAmountOfCharsInPassword && password.length < maxAmountOfCharsInPassword;
}

bool isPasswordHasAtLeastOneLetter(String password) {
  return password.contains(RegExp('[a-zA-Z]'));
}

bool isPasswordHasAtLeastOneNumber(String password) {
  return password.contains(RegExp('[0-9]'));
}

String lastNChars(String string, int n) {
  return string.substring(string.length - n);
}

String removeCharsFrom(String string, int amount) {
  if (string.isEmpty) return '';

  return string.substring(0, string.length - amount);
}

/// Removes cases like:
/// 1) 50.0000 -> 50
/// 2) 4.3320000 -> 4.332
String truncateZerosFrom(String number) {
  final parsed = double.tryParse(number);

  if (parsed == null) {
    return number;
  }

  if (parsed == 0) {
    return '0';
  }

  return parsed % 1 == 0 ? parsed.toInt().toString() : parsed.toString();
}

/// Converts cryptoAddress to [xxxx •••• xxxx] format
String shortAddressForm(String address) {
  final length = address.length;

  if (length <= 8) return address;

  final part1 = address.substring(0, 4);
  final part2 = address.substring(length - 4, length);

  return '$part1 •••• $part2';
}

/// Formatting example: 1705063803232 -> 1705••••3232
String shortTxhashFrom(String address) {
  final length = address.length;

  if (length <= 16) return address;

  final part1 = address.substring(0, 4);
  final part2 = address.substring(length - 4, length);

  return '$part1 •••• $part2';
}

String shortAddressFormTwo(String address) {
  final length = address.length;

  if (length <= 16) return address;

  final part1 = address.substring(0, 8);
  final part2 = address.substring(length - 8, length);

  return '$part1...$part2';
}

String shortIbanFormTwo(String iban) {
  final length = iban.length;

  if (length <= 16) return iban;

  final part1 = iban.substring(0, 4);
  final part2 = iban.substring(length - 4, length);

  return '$part1...$part2';
}

String shortAddressFormThree(String address) {
  final length = address.length;

  if (length <= 12) return address;

  final part1 = address.substring(0, 6);
  final part2 = address.substring(length - 6, length);

  return '$part1...$part2';
}

String shortAddressOperationId(String address) {
  final length = address.length;
  if (length <= 8) return address;

  final part1 = address.split('|').first;

  return part1;
}

Future<bool> isPhoneNumberValid(String phoneNumber, String? isoCode) async {
  try {
    final number = await PhoneNumber.getRegionInfoFromPhoneNumber(
      phoneNumber,
      isoCode ?? '',
    );

    number.parseNumber();

    return true;
  } catch (e) {
    try {
      final newNumber = '+380$phoneNumber';

      final number = await PhoneNumber.getRegionInfoFromPhoneNumber(newNumber);

      number.parseNumber();

      return true;
    } catch (e) {
      return false;
    }
  }
}

/// International only format
Future<bool> isInternationalPhoneNumberValid(
  String phoneNumber,
  String? isoCode,
) async {
  try {
    final number = await PhoneNumber.getRegionInfoFromPhoneNumber(
      phoneNumber,
      isoCode ?? '',
    );

    number.parseNumber();

    return true;
  } catch (e) {
    return false;
  }
}

/// \+ (false) \
/// \+1 (true)  \
/// \+123456789012 (true) \
/// \+1234567890123 (false)
bool validWeakPhoneNumber(String value) {
  final number = value.replaceAll(' ', '');

  const pattern = r'^[+]?[0-9]{1,14}$';

  return RegExp(pattern).hasMatch(number);
}

/// Used for input fields on actions
String formatCurrencyStringAmount({
  @Deprecated('The parameter is not used') String? prefix,
  required String value,
  String? symbol,
}) {
  final chars = value.split('');

  final wholePart = StringBuffer();
  final decimalPart = StringBuffer();

  var beforeDecimal = true;

  for (final char in chars) {
    if (char == '.') {
      beforeDecimal = false;
      continue;
    }
    if (beforeDecimal) {
      wholePart.write(char);
    } else {
      decimalPart.write(char);
    }
  }

  final formatter = DecimalFormatter(NumberFormat.decimalPattern('en-US'));

  final wholePart2 = Decimal.tryParse(wholePart.toString()) ?? Decimal.zero;

  final wholePart3 = formatter.format(wholePart2).replaceAll(',', ' ');

  final amountPart = beforeDecimal ? wholePart3 : '$wholePart3.$decimalPart';

  return symbol != null ? '$amountPart $symbol' : amountPart;
}

Decimal basePrice(
  Decimal assetPriceInUsd,
  BaseCurrencyModel baseCurrency,
  List<CurrencyModel> allCurrencies, {
  bool transactionInCurrent = false,
}) {
  final baseCurrencyMain = currencyFromAll(
    allCurrencies,
    baseCurrency.symbol,
  );

  final usdCurrency = currencyFromAll(
    allCurrencies,
    'USD',
  );

  if (baseCurrency.symbol == 'USD' || transactionInCurrent) {
    return assetPriceInUsd;
  }

  if (baseCurrencyMain.currentPrice == Decimal.zero) {
    return assetPriceInUsd * usdCurrency.currentPrice;
  }

  return Decimal.parse(
    '''${double.parse('$assetPriceInUsd') / double.parse('${baseCurrencyMain.currentPrice}')}''',
  );
}

String getCardTypeMask(String cardNumber) {
  final maskCard = <String>[];
  final splittedCard = cardNumber.split('');

  const totalBlock = 5;
  const spaceCounter = 4;

  var localSpaceCounter = 1;
  var localBlock = 1;

  for (var i = 0; i < splittedCard.length; i++) {
    maskCard.add(splittedCard[i]);

    if (localSpaceCounter == spaceCounter) {
      localSpaceCounter = 1;
      localBlock++;

      if (localBlock != totalBlock) {
        maskCard.add('\u{2005}');
      }
    } else {
      localSpaceCounter++;
    }
  }

  return maskCard.join();
}

String getIBANTypeMask(String iban) {
  final ibanMask = MaskTextInputFormatter(
    mask: '#### #### #### #### #### #### #### #### ##',
    initialText: '',
    filter: {
      '#': RegExp('[a-zA-Z0-9]'),
    },
    type: MaskAutoCompletionType.eager,
  );
  return ibanMask.maskText(iban);
}

bool validLabel(String txt) {
  if (txt.isEmpty) return false;

  final re = RegExp(
    r'^[a-zA-Z\p{N},.:/\s/-]*$',
    unicode: true,
    multiLine: true,
  );

  return !re.hasMatch(txt);
}
