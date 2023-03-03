import 'package:flutter/material.dart';
import 'package:jetwallet/features/nft/nft_details/store/nft_detail_store.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'dart:math' as math;

class NFTDetailHeader extends StatelessWidget {
  const NFTDetailHeader({
    super.key,
    required this.title,
    required this.fImage,
    required this.showImage,
    required this.collectionId,
    required this.objectId,
  });

  final String title;
  final String fImage;
  final String collectionId;
  final String objectId;
  final bool showImage;

  @override
  Widget build(BuildContext con) {
    final colors = sKit.colors;

    return LayoutBuilder(
      builder: (context, c) {
        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings!.maxExtent - settings.minExtent;
        final t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0);
        final fadeStart = math.max(0.0, 1.0 - 220 / deltaExtent);
        const fadeEnd = 1.0;
        final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

        final mediaQuery = MediaQuery.of(context);
        final screenHeight = mediaQuery.size.height;
        final screenWidth = mediaQuery.size.width;
        final qrCodeSize = screenWidth * 0.6;

        return Material(
          color: colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SIconButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    defaultIcon: const SBackIcon(),
                    pressedIcon: const SBackPressedIcon(),
                  ),
                  Opacity(
                    //opacity: 1 - opacity,
                    opacity: showImage ? 0 : 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        fImage,
                        width: 48,
                        height: 48,
                      ),
                    ),
                  ),
                  SIconButton(
                    onTap: () {
                      NFTDetailStore.of(context).share(
                        qrCodeSize,
                        screenWidth * 0.2,
                      );
                    },
                    defaultIcon: const SShareIcon(),
                    pressedIcon: SShareIcon(
                      color: colors.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              if (opacity >= 0.7) ...[
                const SpaceH15(),
                Opacity(
                  opacity: opacity,
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    style: sTextH2Style,
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