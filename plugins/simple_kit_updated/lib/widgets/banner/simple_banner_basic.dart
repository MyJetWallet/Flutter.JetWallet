import 'package:flutter/material.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/button/main/simple_icon_button.dart';

enum BannerCorners { sharp, rounded }

class SBannerBasic extends StatelessWidget {
  const SBannerBasic({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.corners,
    this.onClose,
    this.closeIcon,
  });

  final String text;
  final SvgGenImage icon;
  final Color color;
  final BannerCorners corners;
  final Function()? onClose;
  final SvgGenImage? closeIcon;

  @override
  Widget build(BuildContext context) {
    final onCloseIcon = closeIcon ?? Assets.svg.small.x;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
            ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: 16),
            SIconButton(
              onTap: onClose,
              icon: onCloseIcon.simpleSvg(
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
