import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SActionSheetItem extends StatelessWidget {
  const SActionSheetItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.h,
      child: Column(
        children: [
          const SpaceH10(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SActionBuyIcon(),
              const SpaceW10(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        SizedBox(
                          width: 190.w,
                          child: Baseline(
                            baseline: 17.8.h,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              'Operation name',
                              style: sSubtitle2Style,
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 90.w,
                          child: Text(
                            'Fee 3.5%',
                            textAlign: TextAlign.end,
                            style: sCaptionTextStyle.copyWith(
                              color: SColorsLight().grey3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 190.w,
                      child: Baseline(
                        baseline: 15.5.h,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          'Description',
                          style: sCaptionTextStyle.copyWith(
                            color: SColorsLight().grey3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
