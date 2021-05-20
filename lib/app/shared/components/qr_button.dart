import 'package:flutter/material.dart';

class QrButton extends StatelessWidget {
  const QrButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 40.0,
      icon: const Icon(
        Icons.developer_board,
        color: Colors.black,
      ),
      onPressed: onPressed,
    );
  }
}
