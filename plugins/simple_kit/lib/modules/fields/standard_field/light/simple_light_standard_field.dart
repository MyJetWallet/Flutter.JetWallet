import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_kit/modules/fields/standard_field/base/simple_base_standart_field.dart';
import 'package:simple_kit/simple_kit.dart';

class SimpleLightStandardField extends StatefulWidget {
  const SimpleLightStandardField({
    Key? key,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.autofillHints,
    this.focusNode,
    this.onTap,
    this.onErrorIconTap,
    this.onErase,
    this.onChanged,
    this.suffixIcons,
    this.initialValue,
    this.inputFormatters,
    this.textCapitalization,
    this.disableErrorOnChanged = true,
    this.enableInteractiveSelection = true,
    this.hideClearButton = false,
    this.hideIconsIfNotEmpty = true,
    this.hideIconsIfError = true,
    this.autofocus = false,
    this.readOnly = false,
    this.alignLabelWithHint = false,
    this.enabled = true,
    this.hideSpace = false,
    this.isError = false,
    this.hasManualError = false,
    this.hideLabel = false,
    this.grayLabel = false,
    this.validators = const [],
    this.maxLength,
    this.maxLines,
    required this.labelText,
    this.height,
  })  : assert(
          (controller == null && initialValue != null) ||
              (controller != null && initialValue == null) ||
              (controller == null && initialValue == null),
          "Controller and initialValue can't be both provided",
        ),
        super(key: key);

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final Function()? onTap;
  final Function()? onErrorIconTap;
  final Function()? onErase;
  final Function(String)? onChanged;
  final List<Widget>? suffixIcons;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;
  final bool disableErrorOnChanged;
  final bool enableInteractiveSelection;
  final bool hideClearButton;
  final bool hideIconsIfNotEmpty;
  final bool hideIconsIfError;
  final bool autofocus;
  final bool readOnly;
  final bool alignLabelWithHint;
  final bool enabled;
  final bool hideSpace;
  final String labelText;
  final bool isError;
  final bool hasManualError;
  final bool hideLabel;
  final bool grayLabel;
  final List<Validator> validators;
  final int? maxLength;
  final int? maxLines;
  final double? height;

  @override
  State<SimpleLightStandardField> createState() =>
      _SimpleLightStandardFieldState();
}

class _SimpleLightStandardFieldState extends State<SimpleLightStandardField> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller2 = widget.controller ??
        TextEditingController(
          text: widget.initialValue,
        );

    return SimpleBaseStandardField(
      onTap: widget.onTap,
      labelText: widget.labelText,
      onChanged: (str) {
        setState(() {
          widget.onChanged!(str);
        });
      },
      controller: controller2,
      focusNode: widget.focusNode,
      onErrorIconTap: widget.onErrorIconTap,
      keyboardType: widget.keyboardType,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      alignLabelWithHint: widget.alignLabelWithHint,
      enabled: widget.enabled,
      disableErrorOnChanged: widget.disableErrorOnChanged,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      inputFormatters: widget.inputFormatters,
      hideSpace: widget.hideSpace,
      hasManualError: widget.hasManualError,
      hideLabel: widget.hideLabel,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      grayLabel: widget.grayLabel,
      suffixIcons: [
        if (!widget.hideIconsIfNotEmpty || !controller2.text.isNotEmpty)
          ...?widget.suffixIcons,
      ],
      eraseIcon: [
        if (controller2.text.isNotEmpty && !widget.hideClearButton) ...[
          const SpaceW16(),
          SIconButton(
            defaultIcon: const SEraseIcon(),
            pressedIcon: const SErasePressedIcon(),
            onTap: () {
              setState(() {
                controller2.clear();
                widget.onChanged?.call('');
                widget.onErase?.call();
              });
            },
          ),
        ],
      ],
      isError: widget.isError,
      validators: widget.validators,
      height: widget.height,
    );
  }
}
