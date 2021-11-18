import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_kit/simple_kit.dart';

class PhoneVerificationBlock extends StatelessWidget {
  const PhoneVerificationBlock({
    Key? key,
    required this.onChange,
    required this.isoCode,
    required this.showBottomSheet,
  }) : super(key: key);

  final Function(String value) onChange;
  final Function() showBottomSheet;
  final String isoCode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88.h,
      child: Row(
        children: [
          GestureDetector(
            onTap: showBottomSheet,
            child: Container(
              width: 100.w,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Code',
                    style: sCaptionTextStyle.copyWith(
                      color: SColorsLight().grey2,
                    ),
                  ),
                  Baseline(
                    baseline: 22.h,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      isoCode,
                      style: sSubtitle2Style,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: SColorsLight().grey4,
            width: 1.w,
          ),
          Column(
            children: [
              Container(
                height: 88.h,
                width: 250.w,
                padding: EdgeInsets.only(left: 25.w),
                child: SStandardField(
                  labelText: 'Phone number',
                  autofocus: true,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  alignLabelWithHint: true,
                  onChanged: (String number) => onChange(number),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
