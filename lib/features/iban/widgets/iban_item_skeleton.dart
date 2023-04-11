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
  }) : super(key: key);

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
                  children: const [
                    SSkeletonTextLoader(
                      height: 12,
                      width: 100,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    SpaceH8(),
                    SSkeletonTextLoader(
                      height: 16,
                      width: 180,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              const SpaceW16(),
              const SSkeletonTextLoader(
                height: 24,
                width: 24,
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
            ],
          ),
        ),
        const SpaceH40(),
      ],
    );
  }

}
