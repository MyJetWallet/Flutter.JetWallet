import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/fields/standard_field/base/simple_base_standart_field.dart';
import 'package:simple_kit/simple_kit.dart';

class SimpleLightStandardFieldObscure extends StatefulWidget {
  const SimpleLightStandardFieldObscure({
    Key? key,
    this.controller,
    this.autofillHints,
    this.focusNode,
    //this.errorNotifier,
    this.onErrorIconTap,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.autofocus = false,
    this.isError = false,
    this.validators = const [],
    required this.labelText,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function()? onErrorIconTap;
  final Iterable<String>? autofillHints;
  final Function(String)? onChanged;
  final String labelText;
  final bool autofocus;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isError;
  final List<Validator> validators;

  @override
  State<SimpleLightStandardFieldObscure> createState() =>
      _SimpleLightStandardFieldObscureState();
}

class _SimpleLightStandardFieldObscureState
    extends State<SimpleLightStandardFieldObscure> {
  bool obscure = true;
  bool showSuffix = false;

  late TextEditingController controller2;
  late FocusNode focusNode2;

  void onChanged() {
    setState(() {
      showSuffix = focusNode2.hasFocus || controller2.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    controller2 = widget.controller ?? TextEditingController();
    focusNode2 = widget.focusNode ?? FocusNode();

    focusNode2.addListener(onChanged);
    controller2.addListener(onChanged);

    showSuffix = focusNode2.hasFocus || controller2.text.isNotEmpty;

    super.initState();
  }

  @override
  void dispose() {
    focusNode2.removeListener(onChanged);
    controller2.removeListener(onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleBaseStandardField(
      labelText: widget.labelText,
      onChanged: widget.onChanged,
      controller: widget.controller,
      focusNode: focusNode2,
      obscureText: obscure,
      autofillHints: widget.autofillHints,
      //errorNotifier: widget.errorNotifier,
      onErrorIconTap: widget.onErrorIconTap,
      autofocus: widget.autofocus,
      hideIconsIfError: false,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      maxLines: 1,
      suffixIcons: [
        if (showSuffix)
          InkWell(
            onTap: () {
              setState(() {
                obscure = !obscure;
              });
            },
            splashFactory: NoSplash.splashFactory,
            highlightColor: SColorsLight().white,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: obscure ? const SEyeOpenIcon() : const SEyeCloseIcon(),
            ),
          ),
      ],
      eraseIcon: [
        if (controller2.text.isNotEmpty) ...[
          const SpaceW16(),
          SIconButton(
            defaultIcon: const SEraseIcon(),
            pressedIcon: const SErasePressedIcon(),
            onTap: () {
              setState(() {
                controller2.clear();
                widget.onChanged?.call('');
              });
            },
          ),
        ],
      ],
      isError: widget.isError,
      validators: widget.validators,
    );
  }
}
