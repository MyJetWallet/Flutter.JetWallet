import 'package:simple_kit/simple_kit.dart';

SPhoneNumber? countryCodeByUserRegister(String countryOfRegistration) {
  SPhoneNumber? phoneNumber;

  for (var i = 0; i < sPhoneNumbers.length; i++) {
    if (sPhoneNumbers[i].isoCode.toLowerCase() ==
        countryOfRegistration.toLowerCase()) {
      phoneNumber = sPhoneNumbers[i];
    }
  }

  if (phoneNumber != null) {
    return phoneNumber;
  } else {
    return null;
  }
}
