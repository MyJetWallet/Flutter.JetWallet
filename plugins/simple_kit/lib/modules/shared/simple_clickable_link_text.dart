import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../simple_kit.dart';

class SClickableLinkText extends StatefulWidget {
  const SClickableLinkText({
    Key? key,
    required this.text,
    required this.onTap,
    this.actualColor = const Color(0xFF374DFB),
  }) : super(key: key);

  final String text;
  final void Function() onTap;
  final Color actualColor;

  @override
  State<SClickableLinkText> createState() => _SClickableLinkTextState();
}

class _SClickableLinkTextState extends State<SClickableLinkText> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    late Color currentColor;

    currentColor = highlighted
        ? widget.actualColor.withOpacity(0.8)
        : widget.actualColor;

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
