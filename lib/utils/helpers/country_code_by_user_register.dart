import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/kyc_profile_countries.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/phone_verification/utils/simple_number.dart';
import 'package:jetwallet/features/phone_verification/utils/simple_phone_numbers.dart';

SPhoneNumber? countryCodeByUserRegister() {
  SPhoneNumber? phoneNumber;

  if (sUserInfo.countryOfRegistration.isNotEmpty) {
    for (final number in sPhoneNumbers) {
      if (number.isoCode.toLowerCase() == sUserInfo.countryOfRegistration.toLowerCase()) {
        phoneNumber = number;
      }
    }
  } else {
    final userCountry = getIt.get<ProfileGetUserCountry>();

    for (final number in sPhoneNumbers) {
      if (number.isoCode.toLowerCase() == userCountry.profileUserCountry.countryCode.toLowerCase()) {
        phoneNumber = number;
      }
    }
  }

  return phoneNumber;
}

SPhoneNumber getCountryByCode(String code) {
  final country = sPhoneNumbers.firstWhere(
    (element) => element.isoCode == code,
    orElse: () {
      throw Exception('Invalid country code');
    },
  );
  return country;
}
