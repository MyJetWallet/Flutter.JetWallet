import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';

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
        margin: const EdgeInsets.symmetric(horizontal: 24.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        height: 68,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 53,
              ),
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Image.asset(recurringBuysAsset),
              ),
            ),
            const SpaceW20(),
            SizedBox(
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
