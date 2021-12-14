import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../simple_kit.dart';

class SimpleBaseStandardField extends HookWidget {
  const SimpleBaseStandardField({
    Key? key,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.controller,
    this.focusNode,
    this.errorNotifier,
    this.onErrorIconTap,
    this.onChanged,
    this.suffixIcons,
    this.hideIconsIfError = true,
    this.autofocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.alignLabelWithHint = false,
    required this.labelText,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final StandardFieldErrorNotifier? errorNotifier;
  final Function()? onErrorIconTap;
  final Iterable<String>? autofillHints;
  final Function(String)? onChanged;
  final List<Widget>? suffixIcons;
  final bool hideIconsIfError;
  final bool autofocus;
  final bool readOnly;
  final bool obscureText;
  final bool alignLabelWithHint;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    if (errorNotifier != null) useValueListenable(errorNotifier!);
    final errorValue = errorNotifier?.value ?? false;

    return SizedBox(
      height: 88.0,
      child: Center(
        child: TextField(
          focusNode: focusNode,
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          autofocus: autofocus,
          readOnly: readOnly,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          onChanged: (value) {
            onChanged?.call(value);
            errorNotifier?.disableError();
          },
          cursorWidth: 3.0,
          cursorColor: SColorsLight().blue,
          cursorRadius: Radius.zero,
          style: sSubtitle2Style.copyWith(
            color: errorValue ? SColorsLight().red : SColorsLight().black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: labelText,
            alignLabelWithHint: alignLabelWithHint,
            labelStyle: sSubtitle2Style.copyWith(
              color: SColorsLight().grey2,
            ),
            floatingLabelStyle: sCaptionTextStyle.copyWith(
              fontSize: 16.0,
              color: SColorsLight().grey2,
            ),
            suffixIconConstraints: const BoxConstraints(),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!hideIconsIfError || !errorValue)
                  if (suffixIcons != null)
                    for (final icon in suffixIcons!) ...[
                      icon,
                      if (icon != suffixIcons!.last) const SpaceW20(),
                    ],
                if (errorValue) ...[
                  const SpaceW20(),
                  GestureDetector(
                    onTap: onErrorIconTap,
                    child: const SErrorIcon(),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
