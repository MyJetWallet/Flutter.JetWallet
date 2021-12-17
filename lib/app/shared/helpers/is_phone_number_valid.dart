import 'package:intl_phone_number_input/intl_phone_number_input.dart';

/// International + Local format
Future<bool> isPhoneNumberValid(String phoneNumber) async {
  try {
    final number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);

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
Future<bool> isInternationalPhoneNumberValid(String phoneNumber) async {
  try {
    final number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);

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

  const pattern = r'^[+]?[0-9]{1,12}$';

  return RegExp(pattern).hasMatch(number);
}
