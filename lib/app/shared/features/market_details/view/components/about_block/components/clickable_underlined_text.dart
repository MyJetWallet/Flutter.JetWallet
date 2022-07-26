import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class ClickableUnderlinedText extends HookWidget {
  const ClickableUnderlinedText({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final highlighted = useState(false);

    return InkWell(
      onTap: onTap,
      onHighlightChanged: (value) {
        highlighted.value = value;
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: highlighted.value ? colors.grey1 : colors.black,
            ),
          ),
        ),
        child: Text(
          text,
          style: sBodyText2Style.copyWith(
            color: highlighted.value ? colors.grey1 : colors.black,
          ),
        ),
      ),
    );
  }
}
