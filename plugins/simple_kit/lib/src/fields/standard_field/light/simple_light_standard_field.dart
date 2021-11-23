import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../simple_kit.dart';
import '../base/simple_base_standard_field.dart';
import '../base/standard_field_error_notifier.dart';

class SimpleLightStandardField extends HookWidget {
  const SimpleLightStandardField({
    Key? key,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.autofillHints,
    this.focusNode,
    this.errorNotifier,
    this.onErrorIconTap,
    this.onErase,
    this.alignLabelWithHint = false,
    required this.onChanged,
    required this.labelText,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final StandardFieldErrorNotifier? errorNotifier;
  final Function()? onErrorIconTap;
  final Function()? onErase;
  final Function(String) onChanged;
  final String labelText;
  final bool autofocus;
  final bool alignLabelWithHint;

  @override
  Widget build(BuildContext context) {
    final controller2 = controller ?? useTextEditingController();
    useListenable(controller2);

    return SimpleBaseStandardField(
      labelText: labelText,
      onChanged: onChanged,
      controller: controller2,
      focusNode: focusNode,
      errorNotifier: errorNotifier,
      onErrorIconTap: onErrorIconTap,
      keyboardType: keyboardType,
      autofocus: autofocus,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      alignLabelWithHint: alignLabelWithHint,
      suffixIcon: controller2.text.isNotEmpty
          ? GestureDetector(
              onTap: () {
                controller2.clear();
                onErase?.call();
              },
              child: const SEraseIcon(),
            )
          : const SizedBox(),
    );
  }
}
