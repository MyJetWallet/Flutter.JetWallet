import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionDetailsItem extends StatelessWidget {
  const TransactionDetailsItem({
    Key? key,
    required this.text,
    required this.value,
  }) : super(key: key);

  final String text;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ),
        const Spacer(),
        value,
      ],
    );
  }
}
