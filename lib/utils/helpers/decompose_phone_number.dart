import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:jetwallet/utils/models/phone_number/phone_number_model.dart';
import 'package:logger/logger.dart';

import '../../core/di/di.dart';
import '../../core/services/logger_service/logger_service.dart';

Future<PhoneNumberModel> decomposePhoneNumber(
    String number,
    {
      String isoCodeNumber = '',
    }
  ) async {
  getIt.get<SimpleLoggerService>().log(
    level: Level.info,
    place: 'sendCode',
    message: 'decomposePhoneNumber',
  );
  getIt.get<SimpleLoggerService>().log(
    level: Level.info,
    place: 'decomposePhoneNumber number',
    message: number,
  );
  getIt.get<SimpleLoggerService>().log(
    level: Level.info,
    place: 'decomposePhoneNumber isoCodeNumber',
    message: isoCodeNumber,
  );
  final info = await PhoneNumber.getRegionInfoFromPhoneNumber(
      number,
      isoCodeNumber,
  );
  getIt.get<SimpleLoggerService>().log(
    level: Level.info,
    place: 'decomposePhoneNumber info',
    message: '$info',
  );

  final phoneNumber = PhoneNumber(
    phoneNumber: info.phoneNumber,
    isoCode: info.isoCode,
  );
  getIt.get<SimpleLoggerService>().log(
    level: Level.info,
    place: 'decomposePhoneNumber phoneNumber',
    message: '$phoneNumber',
  );

  final parsable = await PhoneNumber.getParsableNumber(phoneNumber);
  getIt.get<SimpleLoggerService>().log(
    level: Level.info,
    place: 'decomposePhoneNumber parsable',
    message: parsable,
  );

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
