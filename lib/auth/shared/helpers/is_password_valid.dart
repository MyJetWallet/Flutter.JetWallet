bool isPasswordValid(String? password) {
  const pattern = r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,31}$';

  final regexp = RegExp(pattern);

  if (password == null) {
    return false;
  } else if (!regexp.hasMatch(password)) {
    return false;
  }

  return true;
}
