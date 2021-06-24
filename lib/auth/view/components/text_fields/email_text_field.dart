import 'package:flutter/material.dart';
import '../../../helpers/validators.dart';

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
      validator: validateEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Email address',
      ),
    );
  }
}
