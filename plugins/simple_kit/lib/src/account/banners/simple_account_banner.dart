import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../simple_kit.dart';
import '../../banners/rewards_banner/helper/set_circle_background_image.dart';

class SimpleAccountBanner extends StatelessWidget {
  const SimpleAccountBanner({
    Key? key,
    this.imageUrl,
    required this.header,
    required this.description,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  final String? imageUrl;
  final String header;
  final String description;
  final Color color;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          right: 10.w,
        ),
        width: 327.w,
        height: 171.h,
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 20.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: color,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40.r,
              backgroundImage: setCircleBackgroundImage(imageUrl),
            ),
            const SpaceW16(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 8.h,
                  ),
                  child: Baseline(
                    baseline: 20.h,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      header,
                      maxLines: 2,
                      style: sTextH5Style,
                    ),
                  ),
                ),
                SizedBox(
                  width: 177.w,
                  child: Baseline(
                    baseline: 22.h,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      description,
                      maxLines: 4,
                      style: sBodyText2Style.copyWith(
                        color: SColorsLight().grey1,
                     // height: 1.7.h, //Todo: comeback to this
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
