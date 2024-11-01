import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class UserNotyIcon extends StatelessWidget {
  const UserNotyIcon({
    super.key,
    required this.notificationsCount,
    required this.onTap,
  });

  final int notificationsCount;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return SafeGesture(
      onTap: onTap,
      child: Ink(
        width: 32,
        height: 32,
        child: Stack(
          children: [
            Positioned(
              left: 2,
              bottom: 1,
              child: SizedBox(
                height: 24,
                width: 24,
                child: Assets.svg.medium.user.simpleSvg(
                  color: SColorsLight().black,
                ),
              ),
            ),
            if (notificationsCount != 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: ShapeDecoration(
                    color: SColorsLight().blue,
                    shape: const OvalBorder(
                      side: BorderSide(
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignOutside,
                        //color: const Color(0xFFC6B9ED),
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      notificationsCount.toString(),
                      textAlign: TextAlign.center,
                      style: STStyles.callout.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
