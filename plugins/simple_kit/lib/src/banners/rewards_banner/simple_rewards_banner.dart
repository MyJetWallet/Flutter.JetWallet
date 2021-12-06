import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../simple_kit.dart';
import '../../icons/24x24/public/erase/simple_erase_market_icon.dart';

class SRewardBanner extends StatelessWidget {
  const SRewardBanner({
    Key? key,
    this.secondaryText,
    this.imageUrl,
    this.onClose,
    this.fontPrimaryText,
    required this.bannerColor,
    required this.primaryText,
  }) : super(key: key);

  final Color bannerColor;
  final String primaryText;
  final String? secondaryText;
  final String? imageUrl;
  final Function()? onClose;
  final TextStyle? fontPrimaryText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
            bottom: 20.h,
          ),
          //height: 180.h,
          width: 327.w,
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.w,
            bottom: 30.w,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: bannerColor,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40.r,
                backgroundImage:
                    (imageUrl != null) ? NetworkImage(imageUrl!) : null,
              ),
              const SpaceW16(),
              Column(
                mainAxisAlignment: (secondaryText != null)
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 177.w,
                    height: 57.h,
                    child: Baseline(
                      baseline: 27.h,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        primaryText,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        style: fontPrimaryText ?? sTextH4Style,
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
