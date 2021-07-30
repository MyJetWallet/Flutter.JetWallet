import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssetPrice extends StatelessWidget {
  const AssetPrice({
    Key? key,
    required this.price,
  }) : super(key: key);

  final double price;

  @override
  Widget build(BuildContext context) {
    return Text(
      '\$$price',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 35.sp,
        color: Colors.grey[800],
      ),
    );
  }
}
