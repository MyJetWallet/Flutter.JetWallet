import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../simple_kit.dart';
import '../../icons/24x24/public/erase/simple_erase_market_icon.dart';

class SMarketBanner extends StatelessWidget {
  const SMarketBanner({
    Key? key,
    this.imageUrl,
    required this.bannerColor,
    required this.primaryText,
    required this.onClose,
  }) : super(key: key);

  final Color bannerColor;
  final String primaryText;
  final String? imageUrl;
  final Function() onClose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 327.w,
          height: 120.h,
          padding: EdgeInsets.only(
            right: 20.h,
            left: 20.h,
            top: 20.h,
          ),
          decoration: BoxDecoration(
            color: bannerColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40.r,
                backgroundImage:
                    (imageUrl != null) ? NetworkImage(imageUrl!) : null,
              ),
              const SpaceW20(),
              SizedBox(
                width: 183.w,
                height: 64.h,
                child: Baseline(
                  baseline: 32.h,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    'Invite friends and get \$10',
                    maxLines: 2,
                    style: sTextH4Style,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10.h,
          right: 10.w,
          child: GestureDetector(
            onTap: onClose,
            child: SEraseMarketIcon(),
          ),
        ),
        // Positioned(
        //   bottom: 0.h,
        //   left: 0.w,
        //   child: Container(
        //     width: 200,
        //     height: 20,
        //     color: Colors.green,
        //   ),
        // ),
      ],
    );
  }
}
