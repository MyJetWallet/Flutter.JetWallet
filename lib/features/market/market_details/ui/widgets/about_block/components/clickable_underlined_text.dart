import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class ClickableUnderlinedText extends StatefulObserverWidget {
  const ClickableUnderlinedText({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final void Function() onTap;

  @override
  State<ClickableUnderlinedText> createState() =>
      _ClickableUnderlinedTextState();
}

class _ClickableUnderlinedTextState extends State<ClickableUnderlinedText> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return InkWell(
      onTap: widget.onTap,
      onHighlightChanged: (value) {
        highlighted = value;
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: highlighted ? colors.grey1 : colors.black,
            ),
          ),
        ),
        child: Text(
          widget.text,
          style: sBodyText2Style.copyWith(
            color: highlighted ? colors.grey1 : colors.black,
          ),
        ),
      ),
    );
  }
}
