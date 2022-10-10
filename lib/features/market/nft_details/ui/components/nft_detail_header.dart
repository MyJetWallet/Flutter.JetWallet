import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import 'dart:math' as math;

class NFTDetailHeader extends StatelessWidget {
  const NFTDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return LayoutBuilder(
      builder: (context, c) {
        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings!.maxExtent - settings.minExtent;
        final t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0);
        final fadeStart = math.max(0.0, 1.0 - 260 / deltaExtent);
        const fadeEnd = 1.0;
        final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

        return Material(
          color: colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceH64(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SIconButton(
                    onTap: () => Navigator.pop(context),
                    defaultIcon: const SBackIcon(),
                    pressedIcon: const SBackPressedIcon(),
                  ),
                  Opacity(
                    opacity: 1 - opacity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        'https://simple.app/nft/content/full/photo_2022-08-26_13-10-42.png',
                        width: 48,
                        height: 48,
                      ),
                    ),
                  ),
                  SIconButton(
                    onTap: () {},
                    defaultIcon: const SShareIcon(),
                  ),
                ],
              ),
              if (opacity >= 0.75) ...[
                Opacity(
                  opacity: opacity,
                  child: Baseline(
                    baseline: 56.0,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      'Very veryvesdaglajsdgl j aslgdk j long name',
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      style: sTextH2Style,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/*
class NFTDetailHeader extends SliverPersistentHeaderDelegate {
  const NFTDetailHeader();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = shrinkOffset / maxExtent;
    final colors = sKit.colors;

    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH64(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SIconButton(
                onTap: () => Navigator.pop(context),
                defaultIcon: const SBackIcon(),
                pressedIcon: const SBackPressedIcon(),
              ),
            ],
          ),
          Baseline(
            baseline: 56.0,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              'Very veryvesdaglajsdgl j aslgdk j long name',
              textAlign: TextAlign.start,
              maxLines: 3,
              style: sTextH2Style,
            ),
          ),
          const SpaceH28(),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 260;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
*/