import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SIconButton extends HookWidget {
  const SIconButton({
    Key? key,
    this.onTap,
    required this.defaultIcon,
    required this.pressedIcon,
  }) : super(key: key);

  final Function()? onTap;
  final Widget defaultIcon;
  final Widget pressedIcon;

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
      child: highlighted.value ? pressedIcon : defaultIcon,
    );
  }
}
