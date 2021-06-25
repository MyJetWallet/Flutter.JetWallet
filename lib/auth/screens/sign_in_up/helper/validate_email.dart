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
