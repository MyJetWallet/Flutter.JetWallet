import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/shared/safe_gesture.dart';

class UserNotyIcon extends StatelessWidget {
  const UserNotyIcon({
    Key? key,
    required this.notificationsCount,
    required this.onTap,
  }) : super(key: key);

  final int notificationsCount;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return SafeGesture(
      onTap: onTap,
      child: SizedBox(
        height: 24,
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            if (notificationsCount != 0)
              Positioned(
                right: 17,
                top: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: ShapeDecoration(
                    color: SColorsLight().blue,
                    shape: const OvalBorder(
                      side: BorderSide(
                        width: 3,
                        strokeAlign: BorderSide.strokeAlignOutside,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      notificationsCount.toString(),
                      textAlign: TextAlign.center,
                      style: STStyles.callout.copyWith(
                        color: SColorsLight().white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.svg.medium.user.simpleSvg(
                  color: SColorsLight().black,
                ),
                const Gap(24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
