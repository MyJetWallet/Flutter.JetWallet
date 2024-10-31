import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

@Deprecated('This is a widget from the old ui kit, please use the widget from the new ui kit')
class SClickableLinkText extends StatefulWidget {
  const SClickableLinkText({
    super.key,
    required this.text,
    required this.onTap,
    this.actualColor = const Color(0xFF374DFB),
  });

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

    currentColor = highlighted ? widget.actualColor.withOpacity(0.8) : widget.actualColor;

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
