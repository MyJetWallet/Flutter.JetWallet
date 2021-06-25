String? validatePassword(String? value) {
  const pattern = r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,31}$';

  final regExp = RegExp(pattern);
  
  if (value != null && !regExp.hasMatch(value)) {
    return 'Enter a valid password address';
  } else {
    return '';
  }
}
