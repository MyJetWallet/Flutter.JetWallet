import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultIcon extends StatelessWidget {
  const ResultIcon(
    this.icon, {
    Key? key,
    this.color = Colors.black,
  }) : super(key: key);

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 125.r,
      color: color,
    );
  }
}
