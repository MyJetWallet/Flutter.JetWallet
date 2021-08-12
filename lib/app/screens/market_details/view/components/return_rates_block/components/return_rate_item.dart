import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../shared/components/spacers.dart';

class ReturnRateItem extends StatelessWidget {
  const ReturnRateItem({
    Key? key,
    required this.header,
    required this.value,
  }) : super(key: key);

  final String header;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SpaceH8(),
        Text(
          '$value%',
          style: TextStyle(
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
