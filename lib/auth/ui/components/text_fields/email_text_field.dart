import 'package:flutter/material.dart';

import 'text_field_styles.dart';

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
      keyboardType: TextInputType.emailAddress,
      style: baseFieldStyle,
      decoration: emailFieldDecoration,
    );
  }
}
