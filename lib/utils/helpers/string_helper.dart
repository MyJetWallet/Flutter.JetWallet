import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';

bool isEmailValid(String email) {
  const pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r'{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]'
      r'{0,253}[a-zA-Z0-9])?)*$';

  return RegExp(pattern).hasMatch(email);
}

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
