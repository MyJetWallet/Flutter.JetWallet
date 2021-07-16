bool isEmailValid(String? email) {
  const pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r'{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]'
      r'{0,253}[a-zA-Z0-9])?)*$';

  final regexp = RegExp(pattern);

  if (email == null) {
    return false;
  } else if (!regexp.hasMatch(email)) {
    return false;
  }

  return true;
}
