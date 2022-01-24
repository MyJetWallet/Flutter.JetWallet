import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';

SPhoneNumber? countryCodeByUserRegister(Reader read) {
  SPhoneNumber? phoneNumber;
  final userInfo = read(userInfoNotipod);

  if (userInfo.countryOfRegistration.isNotEmpty) {
    for (final number in sPhoneNumbers) {
      if (number.isoCode.toLowerCase() ==
          userInfo.countryOfRegistration.toLowerCase()) {
        phoneNumber = number;
      }
    }
  }

  return phoneNumber;
}
