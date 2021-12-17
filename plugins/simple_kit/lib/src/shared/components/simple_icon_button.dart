import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SIconButton extends HookWidget {
  const SIconButton({
    Key? key,
    this.onTap,
    this.pressedIcon,
    required this.defaultIcon,
  }) : super(key: key);

  final Function()? onTap;
  final Widget? pressedIcon;
  final Widget defaultIcon;

  @override
  Widget build(BuildContext context) {
    final highlighted = useState(false);

    return InkWell(
      onTap: onTap,
      onHighlightChanged: (value) {
        highlighted.value = value;
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: highlighted.value ? (pressedIcon ?? defaultIcon) : defaultIcon,
    );
  }
}
