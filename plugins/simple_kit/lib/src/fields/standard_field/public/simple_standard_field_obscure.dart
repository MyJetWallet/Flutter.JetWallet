import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../current_theme_stpod.dart';
import '../base/standard_field_error_notifier.dart';
import '../light/simple_light_standard_field_obscure.dart';

class SStandardFieldObscure extends ConsumerWidget {
  const SStandardFieldObscure({
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
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return SimpleLightStandardFieldObscure(
        controller: controller,
        focusNode: focusNode,
        errorNotifier: errorNotifier,
        onErrorIconTap: onErrorIconTap,
        onChanged: onChanged,
        labelText: labelText,
      );
    } else {
      return SimpleLightStandardFieldObscure(
        controller: controller,
        focusNode: focusNode,
        errorNotifier: errorNotifier,
        onErrorIconTap: onErrorIconTap,
        onChanged: onChanged,
        labelText: labelText,
      );
    }
  }
}
