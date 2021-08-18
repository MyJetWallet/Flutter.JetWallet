import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssetInputError extends StatelessWidget {
  const AssetInputError({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
