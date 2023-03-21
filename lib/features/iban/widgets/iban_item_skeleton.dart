import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/buttons/simple_icon_button.dart';
import 'package:simple_kit/modules/icons/24x24/public/copy/simple_copy_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/copy/simple_copy_pressed_icon.dart';
import 'package:simple_kit/modules/shared/simple_divider.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_skeleton_text_loader.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

class IBanItemSkeleton extends StatelessObserverWidget {
  const IBanItemSkeleton({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Column(
      children: [
        SPaddingH24(
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 88,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceH21(),
                    Text(
                      name,
                      style: sCaptionTextStyle.copyWith(
                        color: colors.grey2,
                      ),
                    ),
                    SSkeletonTextLoader(
                      height: 28,
                      width: MediaQuery.of(context).size.width - 88,
                    ),
                    const SpaceH21(),
                  ],
                ),
              ),
              const SpaceW16(),
              SIconButton(
                onTap: () {},
                defaultIcon: const SCopyIcon(),
                pressedIcon: const SCopyPressedIcon(),
              ),
            ],
          ),
        ),
        const SDivider(),
      ],
    );
  }

}
