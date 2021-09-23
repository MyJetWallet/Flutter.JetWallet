import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_text_field.dart';

class AppTextFieldObscure extends HookWidget {
  const AppTextFieldObscure({
    Key? key,
    this.autofillHints,
    this.autofocus = false,
    required this.header,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  final Iterable<String>? autofillHints;
  final bool autofocus;
  final String header;
  final String hintText;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final obscure = useState(true);

    return AppTextField(
      header: header,
      hintText: hintText,
      obscureText: obscure.value,
      autofillHints: autofillHints,
      autofocus: autofocus,
      onChanged: onChanged,
      suffixIcon: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => obscure.value = !obscure.value,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 4.5.w,
          ),
          child: Icon(
            Icons.visibility,
            color: Colors.grey,
            size: 20.r,
          ),
        ),
      ),
    );
  }
}
