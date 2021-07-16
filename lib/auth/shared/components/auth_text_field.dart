import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTextField extends HookWidget {
  const AuthTextField({
    Key? key,
    this.obscureText = false,
    required this.header,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  final bool obscureText;
  final String header;
  final String hintText;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final obscure = useState(true);

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
          obscureText: obscureText && obscure.value,
          cursorColor: Colors.grey,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 18.sp,
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
            suffixIcon: obscureText
                ? InkWell(
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
                  )
                : const SizedBox(),
            suffixIconConstraints: const BoxConstraints(),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
