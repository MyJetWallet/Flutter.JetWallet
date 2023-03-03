import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../simple_kit.dart';

class SClickableLinkText extends StatefulWidget {
  const SClickableLinkText({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final void Function() onTap;

  @override
  State<SClickableLinkText> createState() => _SClickableLinkTextState();
}

class _SClickableLinkTextState extends State<SClickableLinkText> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    late Color currentColor;

    currentColor = highlighted
        ? SColorsLight().blue.withOpacity(0.8)
        : SColorsLight().blue;

    return InkWell(
      onTap: widget.onTap,
      onHighlightChanged: (value) {
        setState(() {
          highlighted = value;
        });
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: RichText(
        text: TextSpan(
          text: widget.text,
          style: sSubtitle3Style.copyWith(
            fontFamily: 'Gilroy',
            color: currentColor,
          ),
        ),
      ),
    );
  }
}
