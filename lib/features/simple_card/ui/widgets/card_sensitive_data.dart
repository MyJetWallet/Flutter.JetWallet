import 'package:flutter/material.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/buttons/simple_icon_button.dart';
import 'package:simple_kit/modules/icons/24x24/public/copy/simple_copy_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/copy/simple_copy_pressed_icon.dart';
import 'package:simple_kit/modules/shared/simple_skeleton_text_loader.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

class CardSensitiveData extends StatelessWidget {
  const CardSensitiveData({
    Key? key,
    required this.name,
    required this.value,
    required this.onTap,
    required this.loaderWidth,
    this.showCopy = true,
  }) : super(key: key);

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
          style: sCaptionTextStyle.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.white,
          ),
        ),
        Row(
          children: [
            if (value == '')
              SSkeletonTextLoader(
                height: 18,
                width: loaderWidth,
              )
            else
              Text(
                value,
                style: sSubtitle1Style.copyWith(
                  color: colors.white,
                ),
              ),
            if (showCopy) ...[
              const SpaceW8(),
              SIconButton(
                onTap: () {
                  onTap(value);
                },
                defaultIcon: SCopyIcon(
                  color: colors.white,
                ),
                pressedIcon: const SCopyPressedIcon(),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
