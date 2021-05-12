import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'text_field_styles.dart';

class PasswordTextField extends HookWidget {
  const PasswordTextField({
    Key? key,
    required this.controller,
    this.isRepeat = false,
  }) : super(key: key);

  final TextEditingController controller;
  final bool isRepeat;

  @override
  Widget build(BuildContext context) {
    final isObscure = useState(true);

    return TextFormField(
      controller: controller,
      obscureText: isObscure.value,
      style: baseFieldStyle,
      decoration: passwordFieldDecoration(
        onSuffixTap: () {
          isObscure.value = !isObscure.value;
        },
        isRepeat: isRepeat,
      ),
    );
  }
}
