import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../simple_kit.dart';
import 'helper/set_circle_background_image.dart';

class SRewardBanner extends StatelessWidget {
  const
  SRewardBanner({
    Key? key,
    this.secondaryText,
    this.imageUrl,
    this.onClose,
    this.primaryTextStyle,
    required this.color,
    required this.primaryText,
  }) : super(key: key);

  final Function()? onClose;
  final String? secondaryText;
  final String? imageUrl;
  final TextStyle? primaryTextStyle;
  final Color color;
  final String primaryText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 327.w,
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.w,
            bottom: 30.w,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: color,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40.r,
                backgroundImage: setCircleBackgroundImage(imageUrl),
              ),
              const SpaceW16(),
              Column(
                mainAxisAlignment: (secondaryText != null)
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 177.w,
                    child: Baseline(
                      baseline: 27.h,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        primaryText,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        style: primaryTextStyle ?? sTextH4Style,
                      ),
                    ),
                  ),
                  if (secondaryText != null)
                    SizedBox(
                      width: 177.w,
                      child: Baseline(
                        baseline: 30.h,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          secondaryText!,
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          style: sBodyText2Style.copyWith(
                            color: SColorsLight().grey1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (onClose != null)
          Positioned(
            top: 10.h,
            right: 10.w,
            child: GestureDetector(
              onTap: onClose,
              child: const SEraseMarketIcon(),
            ),
          ),
      ],
    );
  }
}
