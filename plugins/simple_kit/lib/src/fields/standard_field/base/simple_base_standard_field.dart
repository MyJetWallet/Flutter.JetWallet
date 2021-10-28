import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../simple_kit.dart';
import 'standard_field_error_notifier.dart';

class SimpleBaseStandardField extends HookWidget {
  const SimpleBaseStandardField({
    Key? key,
    this.obscureText = false,
    this.controller,
    this.focusNode,
    this.errorNotifier,
    this.onErrorIconTap,
    required this.suffixIcon,
    required this.onChanged,
    required this.labelText,
  }) : super(key: key);

  final bool obscureText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final StandardFieldErrorNotifier? errorNotifier;
  final Function()? onErrorIconTap;
  final Widget suffixIcon;
  final Function(String) onChanged;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    if (errorNotifier != null) useValueListenable(errorNotifier!);
    final errorValue = errorNotifier?.value ?? false;

    return SizedBox(
      height: 88.h,
      child: Center(
        child: TextField(
          focusNode: focusNode,
          controller: controller,
          obscureText: obscureText,
          onChanged: (value) {
            onChanged(value);
            errorNotifier?.disableError();
          },
          cursorWidth: 3.w,
          cursorColor: SColorsLight().blue,
          style: sSubtitle2Style.copyWith(
            color: errorValue ? SColorsLight().red : SColorsLight().black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: labelText,
            labelStyle: sSubtitle2Style.copyWith(
              color: SColorsLight().grey2,
            ),
            floatingLabelStyle: sCaptionTextStyle.copyWith(
              fontSize: 18.sp,
              color: SColorsLight().grey2,
            ),
            suffixIconConstraints: BoxConstraints(
              maxWidth: 24.r,
              maxHeight: 24.r,
              minWidth: 24.r,
              minHeight: 24.r,
            ),
            suffixIcon: errorValue
                ? GestureDetector(
                    onTap: onErrorIconTap,
                    child: const SErrorIcon(),
                  )
                : suffixIcon,
          ),
        ),
      ),
    );
  }
}
