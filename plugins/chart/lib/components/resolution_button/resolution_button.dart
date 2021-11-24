import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResolutionButton extends StatelessWidget {
  const ResolutionButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      margin: EdgeInsets.symmetric(
        horizontal: 5.w,
      ),
      child: MaterialButton(
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}
