import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
      validator: _validate,
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

  String? _validate(String? value) {
    const pattern = r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,31}$';
    final regExp = RegExp(pattern);
    if (value != null && !regExp.hasMatch(value)) {
      return 'Enter a valid password address';
    } else {
      return '';
    }
  }
}
