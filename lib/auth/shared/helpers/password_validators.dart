import '../../../shared/services/remote_config_service/remote_config_values.dart';

bool isPasswordValid(String password) {
  return isPasswordLengthValid(password) &&
      isPasswordHasAtLeastOneLetter(password) &&
      isPasswordHasAtLeastOneNumber(password);
}

bool isPasswordLengthValid(String password) {
  return password.length >= minAmountOfCharsInPassword &&
      password.length < maxAmountOfCharsInPassword;
}

bool isPasswordHasAtLeastOneLetter(String password) {
  return password.contains(RegExp('[a-zA-Z]'));
}

bool isPasswordHasAtLeastOneNumber(String password) {
  return password.contains(RegExp('[0-9]'));
}
