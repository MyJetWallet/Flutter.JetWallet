import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:simple_kit/simple_kit.dart';

SPhoneNumber? countryCodeByUserRegister() {
  SPhoneNumber? phoneNumber;
  final userInfo = getIt.get<UserInfoService>().userInfo;

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
