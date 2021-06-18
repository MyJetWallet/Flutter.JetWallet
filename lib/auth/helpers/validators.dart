String? validateEmail(String? value) {
  const pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r'{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]'
      r'{0,253}[a-zA-Z0-9])?)*$';
  final regex = RegExp(pattern);
  if (value != null && !regex.hasMatch(value)) {
    return 'Enter a valid email address';
  } else {
    return '';
  }
}

String? validatePassword(String? value) {
  const pattern = r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,31}$';
  final regExp = RegExp(pattern);
  if (value != null && !regExp.hasMatch(value)) {
    return 'Enter a valid password address';
  } else {
    return '';
  }
}