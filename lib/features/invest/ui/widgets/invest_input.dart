import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

class InvestInput extends StatefulObserverWidget {
  const InvestInput({
    super.key,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.icon,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.alignLabelWithHint = false,
    this.enabled = true,
    this.inputFormatters,
    this.textCapitalization,
  });

  final Function()? onTap;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final Widget? icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool readOnly;
  final bool obscureText;
  final bool alignLabelWithHint;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;

  @override
  State<InvestInput> createState() => _InvestInputState();
}

class _InvestInputState extends State<InvestInput> {
  FocusNode? focusNode;

  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      focusNode: focusNode,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      enabled: widget.enabled,
      onChanged: (value) {
        widget.onChanged?.call(value);
      },
      cursorWidth: 3.0,
      cursorColor: SColorsLight().blue,
      cursorRadius: Radius.zero,
      style: STStyles.body1InvestSM.copyWith(
        color: widget.enabled ? SColorsLight().black : SColorsLight().grey2,
      ),
      decoration: InputDecoration(
        filled: !widget.enabled,
        fillColor: widget.enabled ? null : SColorsLight().grey5,
        contentPadding: const EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: SColorsLight().grey4),
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: SColorsLight().grey4),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: SColorsLight().grey4),
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: sSubtitle2Style.copyWith(
          color: SColorsLight().grey2,
        ),
        floatingLabelStyle: sCaptionTextStyle.copyWith(
          fontSize: 16.0,
          color: SColorsLight().grey2,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        counterText: '',
        suffixIconConstraints: const BoxConstraints(),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) widget.icon!,
          ],
        ),
      ),
    );
  }
}
