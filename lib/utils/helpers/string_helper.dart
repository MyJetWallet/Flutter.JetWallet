import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';

String localizedMonth(
  String month,
  BuildContext context,
) {
  switch (month) {
    case 'January':
      return intl.january;
    case 'Febuary':
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
  const pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
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
  return password.length >= minAmountOfCharsInPassword &&
      password.length < maxAmountOfCharsInPassword;
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

  final substringAmount = string.substring(0, string.length - amount);

  if (substringAmount.isNotEmpty) {
    if (substringAmount[substringAmount.length - 1] == '.') {
      return string.substring(0, string.length - amount - 1);
    }
  }

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

String shortAddressFormTwo(String address) {
  final length = address.length;

  if (length <= 16) return address;

  final part1 = address.substring(0, 8);
  final part2 = address.substring(length - 8, length);

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
    String phoneNumber, String? isoCode) async {
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
  String? prefix,
  required String value,
  required String symbol,
}) {
  return prefix == null
      ? symbol == 'USD'
          ? '\$$value'
          : '$value $symbol'
      : '$prefix$value';
}
