import 'package:flutter/material.dart';

class ConvertSwitchButton extends StatelessWidget {
  const ConvertSwitchButton({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  final Function() onChanged;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: onChanged,
      icon: const Icon(
        Icons.swap_vert,
        color: Colors.black,
        size: 40.0,
      ),
    );
  }
}
