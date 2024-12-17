import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

class CardSensitiveData extends StatelessWidget {
  const CardSensitiveData({
    super.key,
    required this.name,
    required this.value,
    required this.onTap,
    required this.loaderWidth,
    this.showCopy = true,
  });

  final String name;
  final String value;
  final bool showCopy;
  final double loaderWidth;
  final Function(String value) onTap;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: STStyles.captionBold.copyWith(
            color: colors.white,
          ),
        ),
        Row(
          children: [
            if (value == '')
              SSkeletonLoader(
                height: 18,
                width: loaderWidth,
                borderRadius: BorderRadius.circular(4),
              )
            else
              Text(
                value,
                style: STStyles.subtitle1.copyWith(
                  color: colors.white,
                ),
              ),
            if (showCopy) ...[
              const SpaceW8(),
              Column(
                children: [
                  const SpaceH2(),
                  SafeGesture(
                    onTap: () {
                      onTap(value);
                    },
                    child: Assets.svg.medium.copy.simpleSvg(
                      color: colors.white,
                      width: 16,
                      height: 16,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}
