import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../helper/validate_password.dart';

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
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validatePassword,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        hintText: 'Create a Password',
        suffix: IconButton(
          icon: const Icon(
            Icons.visibility,
            color: Colors.black,
          ),
          onPressed: () {
            isObscure.value = !isObscure.value;
          },
        ),
      ),
    );
  }
}
