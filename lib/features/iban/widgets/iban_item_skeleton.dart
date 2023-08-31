import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_skeleton_text_loader.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';

class IBanItemSkeleton extends StatelessObserverWidget {
  const IBanItemSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SPaddingH24(
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 88,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
