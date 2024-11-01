import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit/simple_kit.dart';
import 'market_header_stats.dart';

class EmptyWatchlist extends StatelessWidget {
  const EmptyWatchlist({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final deviceSize = sDeviceSize;

    return Column(
      children: [
        const ColoredBox(
          color: Colors.white,
          child: MarketHeaderStats(),
        ),
        Expanded(
          child: ColoredBox(
            color: colors.white,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      const Spacer(),
                      deviceSize.when(
                        small: () {
                          return Image.asset(
                            watchlistImageAsset,
                            width: 160,
                          );
                        },
                        medium: () {
                          return Image.asset(
                            watchlistImageAsset,
                            width: 320,
                          );
                        },
                      ),
                      const Spacer(),
                      Text(
                        intl.emptyWatchlist_createYourWatchlist,
                        style: sTextH4Style,
                      ),
                      const SpaceH5(),
                      SPaddingH24(
                        child: Text(
                          intl.emptyWatchlist_starAnAsset,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: sBodyText1Style.copyWith(
                            color: colors.grey1,
                          ),
                        ),
                      ),
                      const SpaceH40(),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
