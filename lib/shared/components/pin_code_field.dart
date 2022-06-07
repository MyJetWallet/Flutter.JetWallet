import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:simple_kit/simple_kit.dart';

class PinCodeField extends HookWidget {
  const PinCodeField({
    Key? key,
    this.focusNode,
    this.autoFocus = false,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    required this.length,
    required this.controller,
    required this.onCompleted,
    required this.pinError,
    required this.onChanged,
  }) : super(key: key);

  final FocusNode? focusNode;
  final bool autoFocus;
  final MainAxisAlignment mainAxisAlignment;
  final int length;
  final TextEditingController controller;
  final Function(String) onCompleted;
  final StandardFieldErrorNotifier pinError;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return PinCodeTextField(
      focusNode: focusNode,
      length: length,
      appContext: context,
      controller: controller,
      autoFocus: autoFocus,
      autoDisposeControllers: false,
      animationType: AnimationType.fade,
      useExternalAutoFillGroup: true,
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: colors.white,
      cursorColor: colors.blue,
      hintCharacter: 'X',
      mainAxisAlignment: mainAxisAlignment,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        fieldWidth: length == 4 ? 56.0 : 48.0,
        fieldHeight: 42.0,
        // colors of the selected box (body and border)
        selectedColor: colors.white,
        // color of the filled box (body and border)
        activeColor: colors.white,
        // color of the inactive box (body and border)
        inactiveColor: colors.white,
      ),
      hintStyle: sTextH2Style.copyWith(color: colors.grey4),
      textStyle: sTextH2Style.copyWith(
        color: pinError.value ? colors.red : colors.black,
      ),
      beforeTextPaste: (_) => false,
      onCompleted: onCompleted,
      onChanged: onChanged, // required field
    );
  }
}
