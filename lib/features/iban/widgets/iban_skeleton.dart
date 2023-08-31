import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_skeleton_text_loader.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';

import 'iban_item_skeleton.dart';

class IBanSkeleton extends StatelessObserverWidget {
  const IBanSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SpaceH30(),
          SPaddingH24(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.grey5,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Row(
                  children: [
                    const SSkeletonTextLoader(
                      height: 80,
                      width: 80,
                      borderRadius: BorderRadius.all(Radius.circular(80)),
                    ),
                    const SpaceW20(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SSkeletonTextLoader(
                          height: 16,
                          width: 80,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        const SpaceH16(),
                        SSkeletonTextLoader(
                          height: 12,
                          width: MediaQuery.of(context).size.width - 188,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        const SpaceH8(),
                        const SSkeletonTextLoader(
                          height: 12,
                          width: 120,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SpaceH33(),
          const IBanItemSkeleton(),
          const IBanItemSkeleton(),
          const IBanItemSkeleton(),
          const SpaceH42(),
        ],
      ),
    );
  }

}
