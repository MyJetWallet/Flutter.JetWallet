import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssetSelectorHeader extends StatelessWidget {
  const AssetSelectorHeader({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        color: Colors.black54,
      ),
    );
  }
}
