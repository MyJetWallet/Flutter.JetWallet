import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../current_theme_stpod.dart';
import '../base/standard_field_error_notifier.dart';
import '../light/simple_light_standard_field.dart';

class SStandardField extends ConsumerWidget {
  const SStandardField({
    Key? key,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.autofillHints,
    this.focusNode,
    this.errorNotifier,
    this.onErrorIconTap,
    this.suffixIcons,
    this.onErase,
    this.onChanged,
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
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return SimpleLightStandardField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        focusNode: focusNode,
        errorNotifier: errorNotifier,
        onErrorIconTap: onErrorIconTap,
        onChanged: onChanged,
        labelText: labelText,
        autofocus: autofocus,
        autofillHints: autofillHints,
        alignLabelWithHint: alignLabelWithHint,
        onErase: onErase,
        suffixIcons: suffixIcons,
        hideIconsIfError: hideIconsIfError,
        hideIconsIfNotEmpty: hideIconsIfNotEmpty,
      );
    } else {
      return SimpleLightStandardField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        focusNode: focusNode,
        errorNotifier: errorNotifier,
        onErrorIconTap: onErrorIconTap,
        onChanged: onChanged,
        labelText: labelText,
        autofocus: autofocus,
        autofillHints: autofillHints,
        alignLabelWithHint: alignLabelWithHint,
        onErase: onErase,
        suffixIcons: suffixIcons,
        hideIconsIfError: hideIconsIfError,
        hideIconsIfNotEmpty: hideIconsIfNotEmpty,
      );
    }
  }
}
