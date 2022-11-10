abstract class Validator<T> {
  final ValidatorException error;

  Validator(this.error);

  bool checkValid(T value);
}

class ValidatorException implements Exception {
  final String message;

  ValidatorException(this.message);
}
