import 'package:flutter/material.dart';
import 'package:simple_kit/modules/icons/24x24/light/star/simple_light_star_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';

class TransactionListLoadingItem extends StatelessWidget {
  const TransactionListLoadingItem({
    super.key,
    required this.opacity,
    this.removeDivider = false,
  });

  final bool removeDivider;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: SPaddingH24(
        child: SizedBox(
          height: 80,
          child: Column(
            children: [
              const SpaceH18(),
              const Row(
                children: [
                  SpaceW2(),
                  SSkeletonTextLoader(
                    height: 16,
                    width: 16,
                  ),
                  SpaceW12(),
                  SSkeletonTextLoader(
                    height: 16,
                    width: 80,
                  ),
                  Spacer(),
                  SSkeletonTextLoader(
                    height: 16,
                    width: 80,
                  ),
                  SpaceW8(),
                  SimpleFullLightStarIcon(),
                ],
              ),
              const SpaceH12(),
              const Row(
                children: [
                  SpaceW30(),
                  SSkeletonTextLoader(
                    height: 10,
                    width: 32,
                  ),
                  Spacer(),
                  SSkeletonTextLoader(
                    height: 10,
                    width: 60,
                  ),
                  SpaceW8(),
                  Opacity(
                    opacity: 0,
                    child: SimpleLightStarIcon(),
                  ),
                ],
              ),
              const Spacer(),
              if (!removeDivider) const SDivider(),
            ],
          ),
        ),
      ),
    );
  }
}
