import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QrButton extends StatelessWidget {
  const QrButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 32.w,
      icon: const Icon(
        Icons.developer_board,
        color: Colors.black,
      ),
      onPressed: onPressed,
    );
  }
}
