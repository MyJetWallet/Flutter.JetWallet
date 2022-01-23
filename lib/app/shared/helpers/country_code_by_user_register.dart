import 'package:simple_kit/simple_kit.dart';

SPhoneNumber? countryCodeByUserRegister(String countryOfRegistration) {
  SPhoneNumber? phoneNumber;

  for (var i = 0; i < sPhoneNumbers.length; i++) {
    if (sPhoneNumbers[i].alphaCode.toLowerCase() ==
        countryOfRegistration.toLowerCase()) {
      phoneNumber = sPhoneNumbers[i];
    }
  }

  return phoneNumber;
}
