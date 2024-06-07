import 'package:flutter/material.dart';

class SIconButton extends StatelessWidget {
  const SIconButton({
    super.key,
    this.onTap,
    required this.icon,
  });

  final Function()? onTap;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: icon,
    );
  }
}
