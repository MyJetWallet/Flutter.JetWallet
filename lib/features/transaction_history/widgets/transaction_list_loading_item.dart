import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/star/simple_light_star_icon.dart';

class TransactionListLoadingItem extends StatelessWidget {
  const TransactionListLoadingItem({
    super.key,
    required this.opacity,
    this.removeDivider = false,
    this.fromMarket = false,
  });

  final bool removeDivider;
  final double opacity;
  final bool fromMarket;

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
              Row(
                children: [
                  const SpaceW2(),
                  const SSkeletonLoader(
                    height: 16,
                    width: 16,
                  ),
                  const SpaceW12(),
                  const SSkeletonLoader(
                    height: 16,
                    width: 80,
                  ),
                  const Spacer(),
                  const SSkeletonLoader(
                    height: 16,
                    width: 80,
                  ),
                  if (fromMarket) ...[
                    const SpaceW8(),
                    Opacity(
                      opacity: fromMarket ? 1 : 0,
                      child: const SimpleFullLightStarIcon(),
                    ),
                  ],
                ],
              ),
              const SpaceH12(),
              Row(
                children: [
                  const SpaceW30(),
                  const SSkeletonLoader(
                    height: 10,
                    width: 32,
                  ),
                  const Spacer(),
                  const SSkeletonLoader(
                    height: 10,
                    width: 60,
                  ),
                  if (fromMarket) ...[
                    const SpaceW8(),
                    const Opacity(
                      opacity: 0,
                      child: SimpleLightStarIcon(),
                    ),
                  ],
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
