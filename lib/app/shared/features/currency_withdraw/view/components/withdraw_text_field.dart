import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/components/spacers.dart';
import '../../../../components/qr_button.dart';

class WithdrawTextField extends StatelessWidget {
  const WithdrawTextField({
    Key? key,
    required this.title,
    required this.onChanged,
    required this.decoration,
    required this.onQrPressed,
  }) : super(key: key);

  final String title;
  final Function(String) onChanged;
  final InputDecoration decoration;
  final Function() onQrPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
          ),
        ),
        const SpaceH4(),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: onChanged,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: decoration,
              ),
            ),
            const SpaceW4(),
            QrButton(
              onPressed: onQrPressed,
            ),
          ],
        ),
      ],
    );
  }
}
