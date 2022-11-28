import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';

/// Validator that checks email for correct input
class PasswordValidator implements Validator<String> {
  PasswordValidator(this.error);

  @override
  final ValidatorException error;

  @override
  bool checkValid(String password) {
    return isPasswordLengthValid(password) &&
        isPasswordHasAtLeastOneLetter(password) &&
        isPasswordHasAtLeastOneNumber(password);
  }
}
