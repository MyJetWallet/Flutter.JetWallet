import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeField extends StatelessWidget {
  const PinCodeField({
    Key? key,
    this.autoFocus = false,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    required this.length,
    required this.controller,
    required this.onCompleted,
  }) : super(key: key);

  final bool autoFocus;
  final MainAxisAlignment mainAxisAlignment;
  final int length;
  final TextEditingController controller;
  final Function(String) onCompleted;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      length: length,
      appContext: context,
      controller: controller,
      autoFocus: autoFocus,
      autoDisposeControllers: false,
      animationType: AnimationType.fade,
      useExternalAutoFillGroup: true,
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.white,
      cursorColor: Colors.black,
      hintCharacter: 'X',
      mainAxisAlignment: mainAxisAlignment,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        fieldWidth: 46.w,
        fieldHeight: 42.h,
        shape: PinCodeFieldShape.underline,
        borderRadius: BorderRadius.circular(10.r),
        // colors of the selected box (body and border)
        selectedFillColor: Colors.grey[200],
        selectedColor: Colors.black,
        // color of the filled box (body and border)
        activeFillColor: Colors.white,
        activeColor: Colors.grey,
        // color of the inactive box (body and border)
        inactiveFillColor: Colors.white,
        inactiveColor: Colors.grey,
      ),
      hintStyle: TextStyle(
        fontSize: 38.sp,
        color: Colors.grey,
      ),
      textStyle: TextStyle(
        fontSize: 38.sp,
        color: Colors.black,
      ),
      onCompleted: onCompleted,
      onChanged: (_) {}, // required field
    );
  }
}
