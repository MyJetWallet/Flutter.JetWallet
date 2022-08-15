import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../simple_kit.dart';
import '../../../colors/view/simple_colors_light.dart';

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
    this.inputFormatters,
    this.textCapitalization,
    this.disableErrorOnChanged = true,
    this.enableInteractiveSelection = true,
    this.hideIconsIfError = true,
    this.autofocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.alignLabelWithHint = false,
    this.enabled = true,
    this.hideSpace = false,
    this.hasManualError = false,
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
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;
  final bool disableErrorOnChanged;
  final bool enableInteractiveSelection;
  final bool hideIconsIfError;
  final bool autofocus;
  final bool readOnly;
  final bool obscureText;
  final bool alignLabelWithHint;
  final bool enabled;
  final bool hideSpace;
  final bool hasManualError;
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
          inputFormatters: inputFormatters,
          autofillHints: autofillHints,
          enableInteractiveSelection: enableInteractiveSelection,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          enabled: enabled,
          onChanged: (value) {
            onChanged?.call(value);
            if (disableErrorOnChanged) {
              errorNotifier?.disableError();
            }
          },
          cursorWidth: 3.0,
          cursorColor: SColorsLight().blue,
          cursorRadius: Radius.zero,
          style: sSubtitle2Style.copyWith(
            color: (errorValue || hasManualError)
                ? SColorsLight().red
                : SColorsLight().black,
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
                      if (icon != suffixIcons!.last && !hideSpace)
                        const SpaceW20(),
                    ],
                if (errorValue) ...[
                  const SpaceW40(),
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
