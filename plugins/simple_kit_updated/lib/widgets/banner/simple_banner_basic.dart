import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

enum BannerCorners { sharp, rounded }

class SBannerBasic extends StatelessWidget {
  const SBannerBasic({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.corners,
    this.customTextWidget,
    this.onClose,
    this.closeIcon,
  });

  final String text;
  final SvgGenImage icon;
  final Color color;
  final BannerCorners corners;
  final Widget? customTextWidget;
  final Function()? onClose;
  final SvgGenImage? closeIcon;

  @override
  Widget build(BuildContext context) {
    final onCloseIcon = closeIcon ?? Assets.svg.small.x;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 16),
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(corners == BannerCorners.rounded ? 16 : 0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: OneColumnCell(
              icon: icon,
              text: text,
              needHorizontalPading: false,
              customTextWidget: customTextWidget,
            ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: 16),
            SafeGesture(
              onTap: onClose,
              child: onCloseIcon.simpleSvg(
                width: 20,
                height: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
