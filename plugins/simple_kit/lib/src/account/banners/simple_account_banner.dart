import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../simple_kit.dart';
import '../../banners/rewards_banner/helper/set_circle_background_image.dart';
import '../../colors/view/simple_colors_light.dart';

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
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: color,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: setCircleBackgroundImage(imageUrl),
            ),
            const SpaceW16(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 14,
                  ),
                  child: Baseline(
                    baseline: 20,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      header,
                      maxLines: 2,
                      style: sTextH5Style,
                    ),
                  ),
                ),
                SizedBox(
                  width: 177,
                  child: Baseline(
                    baseline: 22,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      description,
                      maxLines: 4,
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
    );
  }
}
