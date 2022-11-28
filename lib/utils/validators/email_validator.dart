import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';

/// Validator that checks email for correct input
class EmailValidator implements Validator<String> {
  EmailValidator(this.error);

  @override
  final ValidatorException error;

  @override
  bool checkValid(String value) {
    return isEmailValid(value);
  }
}
