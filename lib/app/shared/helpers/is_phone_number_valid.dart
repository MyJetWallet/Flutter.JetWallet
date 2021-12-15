import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
