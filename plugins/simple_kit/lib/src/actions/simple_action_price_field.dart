import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';

class SActionPriceField extends StatelessWidget {
  const SActionPriceField({
    Key? key,
    required this.price,
    required this.helper,
    required this.error,
    required this.isErrorActive,
  }) : super(key: key);

  final String price;
  final String helper;
  final String error;
  final bool isErrorActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SBaselineChild(
          baseline: 60.h,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              price,
              maxLines: 1,
              style: sTextH1Style.copyWith(
                color:
                    isErrorActive ? SColorsLight().red : SColorsLight().black,
              ),
            ),
          ),
        ),
        SBaselineChild(
          baseline: 24.h,
          child: Text(
            isErrorActive ? error : helper,
            maxLines: 1,
            style: sSubtitle3Style.copyWith(
              color: isErrorActive ? SColorsLight().red : SColorsLight().black,
            ),
          ),
        ),
      ],
    );
  }
}
