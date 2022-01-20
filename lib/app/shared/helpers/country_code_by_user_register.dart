import 'package:simple_kit/simple_kit.dart';

SPhoneNumber? countryCodeByUserRegister(String countryOfRegistration) {
  SPhoneNumber? phoneNumber;

  final countryIsoCodeOfUserRegistration = countryOfRegistration.toLowerCase();

  for (var i = 0; i < sPhoneNumbers.length; i++) {
    if (sPhoneNumbers[i].isoCode.toLowerCase() ==
        countryIsoCodeOfUserRegistration) {
      phoneNumber = sPhoneNumbers[i];
    }
  }

  if (phoneNumber != null) {
    return phoneNumber;
  } else {
    return null;
  }
}
