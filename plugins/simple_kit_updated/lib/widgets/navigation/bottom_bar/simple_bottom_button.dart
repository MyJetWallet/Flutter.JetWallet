import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/navigation/bottom_bar/notification_box.dart';

class SBottomButton extends StatelessWidget {
  const SBottomButton({
    super.key,
    required this.icon,
    required this.text,
    required this.isActive,
    required this.onChanged,
    required this.width,
    required this.notification,
  });

  final SvgGenImage icon;
  final String text;
  final bool isActive;
  final VoidCallback onChanged;
  final double width;

  final int notification;

  @override
  Widget build(BuildContext context) {
    return SafeGesture(
      onTap: onChanged,
      highlightColor: Colors.transparent,
      child: Stack(
        children: [
          SizedBox(
            height: 56,
            width: width,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  icon.simpleSvg(
                    color: isActive ? SColorsLight().black : SColorsLight().gray6,
                  ),
                  const Gap(4),
                  Text(
                    text,
                    style: STStyles.body2Semibold.copyWith(
                      color: isActive ? SColorsLight().black : SColorsLight().gray6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (notification != 0)
            Positioned(
              right: 15,
              top: -5,
              child: NotificationBox(
                notifications: notification,
              ),
            ),
        ],
      ),
    );
  }
}
