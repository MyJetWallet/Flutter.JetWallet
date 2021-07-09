import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../components/qr_button.dart';

class DepositField extends StatelessWidget {
  const DepositField({
    Key? key,
    required this.name,
    required this.value,
    required this.onQrPressed,
  }) : super(key: key);

  final String name;
  final String value;
  final Function() onQrPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SelectableText(
          value,
          style: TextStyle(
            fontSize: 16.sp,
          ),
        ),
        QrButton(
          onPressed: onQrPressed,
        ),
      ],
    );
  }
}
