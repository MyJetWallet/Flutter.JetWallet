import 'package:flutter/material.dart';

/// Use this function if you don't want your TextField to trigger onTap. \
/// Possible use cases: When you have suffixIcon inside the TextField.
/// If you tap on suffixIcon, TextField will be focused, but sometimes there is 
/// no need for focusing. This function will solve this issue.
Future<void> textFieldTapWithoutFocus({
  required FocusNode focusNode,
  required Function() onTap,
}) async {
  focusNode.unfocus();
  focusNode.canRequestFocus = false;
  await Future.delayed(Duration.zero);
  onTap();
  focusNode.canRequestFocus = true;
}
