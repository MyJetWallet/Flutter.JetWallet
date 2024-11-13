import 'package:flutter/material.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/shared/simple_skeleton_loader.dart';

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
    final colors = sKit.colors;

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
