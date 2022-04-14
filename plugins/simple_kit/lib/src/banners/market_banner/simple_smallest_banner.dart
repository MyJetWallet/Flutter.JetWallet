import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';
import '../rewards_banner/helper/set_circle_background_image.dart';

class SSmallestBanner extends StatelessWidget {
  const SSmallestBanner({
    Key? key,
    this.imageUrl,
    required this.color,
    required this.primaryText,
    required this.onTap,
  }) : super(key: key);

  final String? imageUrl;
  final Color color;
  final String primaryText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        width: 327,
        height: 68,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 53,
              ),
              child: CircleAvatar(
                radius: 24.0,
                backgroundImage: setCircleBackgroundImage(
                  imageUrl,
                ),
              ),
            ),
            const SpaceW20(),
            SizedBox(
              width: 160,
              child: Text(
                primaryText,
                maxLines: 2,
                style: sSubtitle3Style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
