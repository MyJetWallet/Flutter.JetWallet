import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../simple_kit.dart';
import '../base/simple_base_standard_field.dart';
import '../base/standard_field_error_notifier.dart';

class SimpleLightStandardFieldObscure extends HookWidget {
  const SimpleLightStandardFieldObscure({
    Key? key,
    this.autofocus = false,
    this.controller,
    this.autofillHints,
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
  final Iterable<String>? autofillHints;
  final Function(String) onChanged;
  final String labelText;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final controller2 = controller ?? useTextEditingController();
    final focusNode2 = focusNode ?? useFocusNode();
    useListenable(controller2);
    useListenable(focusNode2);

    final obscure = useState(true);

    return SimpleBaseStandardField(
      labelText: labelText,
      onChanged: onChanged,
      controller: controller2,
      focusNode: focusNode2,
      obscureText: obscure.value,
      autofillHints: autofillHints,
      errorNotifier: errorNotifier,
      onErrorIconTap: onErrorIconTap,
      autofocus: autofocus,
      suffixIcon: focusNode2.hasFocus || controller2.text.isNotEmpty
          ? GestureDetector(
              onTap: () => obscure.value = !obscure.value,
              child:
                  obscure.value ? const SEyeOpenIcon() : const SEyeCloseIcon(),
            )
          : const SizedBox(),
    );
  }
}
