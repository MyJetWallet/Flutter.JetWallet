import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwapButton extends StatelessWidget {
  const SwapButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.swap_vert,
        size: 35.r,
        color: Colors.grey,
      ),
      padding: EdgeInsets.zero,
    );
  }
}
