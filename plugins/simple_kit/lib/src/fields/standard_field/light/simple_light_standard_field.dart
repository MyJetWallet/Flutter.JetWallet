import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../simple_kit.dart';
import '../base/simple_base_standard_field.dart';
import '../base/standard_field_error_notifier.dart';

class SimpleLightStandardField extends HookWidget {
  const SimpleLightStandardField({
    Key? key,
    this.controller,
    this.focusNode,
    this.errorNotifier,
    this.onErrorIconTap,
    required this.onChanged,
    required this.labelText,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final StandardFieldErrorNotifier? errorNotifier;
  final Function()? onErrorIconTap;
  final Function(String) onChanged;
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
      suffixIcon: controller2.text.isNotEmpty
          ? GestureDetector(
              onTap: () => controller2.clear(),
              child: const SEraseIcon(),
            )
          : const SizedBox(),
    );
  }
}
