import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: _validate,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Email address',
      ),
    );
  }

  String? _validate(String? value) {
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
}
