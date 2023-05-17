import 'package:simple_kit/helpers/validators/validator.dart';

class LatinValidator implements Validator<String> {
  @override
  final ValidatorException error;

  LatinValidator(this.error);

  @override
  bool checkValid(String value) {
    return RegExp(
      r'^[a-zA-Z -.]+$',
      caseSensitive: false,
    ).hasMatch(value);
  }
}
