import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../simple_kit.dart';
import '../base/simple_base_standard_field.dart';
import '../base/standard_field_error_notifier.dart';

class SimpleLightStandardField extends HookWidget {
  const SimpleLightStandardField({
    Key? key,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.autofillHints,
    this.focusNode,
    this.errorNotifier,
    this.onErrorIconTap,
    this.onErase,
    this.onChanged,
    this.suffixIcons,
    this.hideIconsIfNotEmpty = true,
    this.hideIconsIfError = true,
    this.autofocus = false,
    this.alignLabelWithHint = false,
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
  final Function(String)? onChanged;
  final List<Widget>? suffixIcons;
  final bool hideIconsIfNotEmpty;
  final bool hideIconsIfError;
  final bool autofocus;
  final bool alignLabelWithHint;
  final String labelText;

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
      suffixIcons: [
        if (!hideIconsIfNotEmpty || !controller2.text.isNotEmpty)
          ...?suffixIcons,
        if (controller2.text.isNotEmpty)
          GestureDetector(
            onTap: () {
              controller2.clear();
              onErase?.call();
            },
            child: const SEraseIcon(),
          )
      ],
    );
  }
}
