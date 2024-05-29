import 'package:flutter/material.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

enum BannerCorners { sharp, rounded }

class SBannerBasic extends StatelessWidget {
  const SBannerBasic({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.corners,
  });

  final String text;
  final SvgGenImage icon;
  final Color color;
  final BannerCorners corners;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(corners == BannerCorners.rounded ? 16 : 0),
        ),
      ),
      child: OneColumnCell(
        icon: icon,
        text: text,
        needHorizontalPading: false,
      ),
    );
  }
}
