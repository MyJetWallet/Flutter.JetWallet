import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends HookWidget {
  const AppTextField({
    Key? key,
    this.autofillHints,
    this.controller,
    this.focusNode,
    this.fontSize,
    this.suffixIcon,
    this.keyboardType,
    this.autofocus = false,
    this.obscureText = false,
    required this.header,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  final Iterable<String>? autofillHints;
  final bool autofocus;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final double? fontSize;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String header;
  final String hintText;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyle(
            fontSize: 14.sp,
          ),
        ),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          cursorColor: Colors.grey,
          keyboardType: keyboardType,
          autofillHints: autofillHints,
          autofocus: autofocus,
          style: TextStyle(
            fontSize: fontSize ?? 18.sp,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: fontSize ?? 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 5.h,
            ),
            isDense: true,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black54,
                width: 2.w,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black54,
                width: 2.w,
              ),
            ),
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
