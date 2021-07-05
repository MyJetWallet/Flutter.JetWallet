import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/components/spacers.dart';
import '../../../../styles/amount_field_decoration.dart';

class ConvertAmountField extends StatelessWidget {
  const ConvertAmountField({
    Key? key,
    required this.symbol,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);

  final String symbol;
  final Function(String) onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 125.w,
          height: 32.h,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
            ),
            decoration: amountFieldDecoration.copyWith(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 8.h,
              ),
            ),
            onChanged: onChanged,
          ),
        ),
        const SpaceW4(),
        Text(
          symbol,
          style: TextStyle(
            fontSize: 22.sp,
          ),
        )
      ],
    );
  }
}
