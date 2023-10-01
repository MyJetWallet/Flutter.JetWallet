import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';

class SimpleBaseStandardField extends StatefulWidget {
  const SimpleBaseStandardField({
    Key? key,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.controller,
    this.focusNode,
    //this.errorNotifier,
    this.onTap,
    this.onErrorIconTap,
    this.onChanged,
    this.suffixIcons,
    this.eraseIcon,
    this.inputFormatters,
    this.textCapitalization,
    this.maxLength,
    this.maxLines,
    this.disableErrorOnChanged = true,
    this.enableInteractiveSelection = true,
    this.hideIconsIfError = true,
    this.autofocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.alignLabelWithHint = false,
    this.enabled = true,
    this.hideSpace = false,
    this.isError = false,
    this.validators = const [],
    this.hasManualError = false,
    this.hideLabel = false,
    this.grayLabel = false,
    required this.labelText,
    this.height,
    this.cursorHeight,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Function()? onErrorIconTap;
  final Function()? onTap;
  final Iterable<String>? autofillHints;
  final Function(String)? onChanged;
  final List<Widget>? suffixIcons;
  final List<Widget>? eraseIcon;
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
  final String labelText;
  final bool isError;
  final bool hasManualError;
  final bool grayLabel;
  final bool hideLabel;
  final List<Validator> validators;
  final int? maxLength;
  final int? maxLines;
  final double? height;
  final double? cursorHeight;

  @override
  State<SimpleBaseStandardField> createState() => _SimpleBaseStandardFieldState();
}

class _SimpleBaseStandardFieldState extends State<SimpleBaseStandardField> {
  FocusNode? focusNode;

  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: widget.height ?? 88,
        maxHeight: widget.height ?? double.infinity,
      ),
      child: Center(
        child: TextFormField(
          cursorHeight: widget.cursorHeight,
          onTap: widget.onTap,
          focusNode: focusNode,
          controller: widget.controller,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          autofocus: widget.autofocus,
          readOnly: widget.readOnly,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          autofillHints: widget.autofillHints,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
          enabled: widget.enabled,
          onChanged: (value) {
            widget.onChanged?.call(value);
          },
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          maxLengthEnforcement: widget.maxLength != null ? MaxLengthEnforcement.truncateAfterCompositionEnds : null,
          cursorWidth: 3.0,
          cursorColor: SColorsLight().blue,
          cursorRadius: Radius.zero,
          style: sSubtitle2Style.copyWith(
            color: (widget.isError || widget.hasManualError)
                ? SColorsLight().red
                : widget.grayLabel
                    ? SColorsLight().grey2
                    : SColorsLight().black,
          ),
          validator: (value) {
            for (final validator in widget.validators) {
              if (!validator.checkValid(value)) {
                return '';
              }
            }

            return null;
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: widget.labelText,
            alignLabelWithHint: widget.alignLabelWithHint,
            labelStyle: sSubtitle2Style.copyWith(
              color: SColorsLight().grey2,
            ),
            floatingLabelStyle: sCaptionTextStyle.copyWith(
              fontSize: 16.0,
              color: SColorsLight().grey2,
            ),
            floatingLabelBehavior: widget.hideLabel ? FloatingLabelBehavior.never : null,
            counterText: '',
            errorText: null,
            errorMaxLines: null,
            suffixIconConstraints: const BoxConstraints(),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!widget.hideIconsIfError || !widget.isError)
                  if (widget.suffixIcons != null)
                    for (final icon in widget.suffixIcons!) ...[
                      icon,
                      if (icon != widget.suffixIcons!.last && !widget.hideSpace) const SpaceW20(),
                    ],
                if (widget.eraseIcon != null) ...[
                  ...widget.eraseIcon!,
                ],
                if (widget.isError) ...[
                  if (widget.eraseIcon == null) ...[
                    if (!widget.hideIconsIfError) const SpaceW20() else const SpaceW40(),
                  ] else ...[
                    const SpaceW16(),
                  ],
                  GestureDetector(
                    onTap: widget.onErrorIconTap,
                    child: const SErrorIcon(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/*
class SimpleBaseStandardField extends StatelessWidget {
  const SimpleBaseStandardField({
    Key? key,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.controller,
    this.focusNode,
    //this.errorNotifier,
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
    required this.labelText,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  //final StandardFieldErrorNotifier? errorNotifier;
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
  final String labelText;

  @override
  Widget build(BuildContext context) {
    //if (errorNotifier != null) useValueListenable(errorNotifier!);
    // final errorValue = errorNotifier?.value ?? false;

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
              //errorNotifier?.disableError();
            }
          },
          cursorWidth: 3.0,
          cursorColor: SColorsLight().blue,
          cursorRadius: Radius.zero,
          style: sSubtitle2Style.copyWith(
              // color: errorValue ? SColorsLight().red : SColorsLight().black,
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
                //if (!hideIconsIfError || !errorValue)
                if (!hideIconsIfError)
                  if (suffixIcons != null)
                    for (final icon in suffixIcons!) ...[
                      icon,
                      if (icon != suffixIcons!.last && !hideSpace)
                        const SpaceW20(),
                    ],
                /*
                if (errorValue) ...[
                  const SpaceW40(),
                  GestureDetector(
                    onTap: onErrorIconTap,
                    child: const SErrorIcon(),
                  ),
                ],
                */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/
