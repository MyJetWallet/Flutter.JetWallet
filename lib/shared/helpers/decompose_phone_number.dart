import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../model/phone_number_model.dart';

Future<PhoneNumberModel> decomposePhoneNumber(String number) async {
  final info = await PhoneNumber.getRegionInfoFromPhoneNumber(number);

  final phoneNumber = PhoneNumber(
    phoneNumber: info.phoneNumber,
    isoCode: info.isoCode,
  );

  final parsable = await PhoneNumber.getParsableNumber(phoneNumber);

  final isoCode = info.isoCode;
  final dialCode = info.dialCode;
  final body = parsable
      .replaceAll(' ', '')
      .replaceAll('(', '')
      .replaceAll(')', '')
      .replaceAll('-', '');

  return PhoneNumberModel(
    isoCode: isoCode ?? 'N/A',
    dialCode: dialCode ?? 'N/A',
    body: body,
  );
}
