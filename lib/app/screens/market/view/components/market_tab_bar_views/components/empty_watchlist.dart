import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/constants.dart';
import '../../../../../../../shared/providers/device_size/device_size_pod.dart';
import 'market_header_stats.dart';

class EmptyWatchlist extends HookWidget {
  const EmptyWatchlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final deviceSize = useProvider(deviceSizePod);

    return Column(
      children: [
        Container(
          color: Colors.white,
          child: const MarketHeaderStats(),
        ),
        Expanded(
          child: Container(
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
                        'Create your Watchlist',
                        style: sTextH4Style,
                      ),
                      const SpaceH5(),
                      Text(
                        'Star an asset to add it to your Watchlist',
                        style: sBodyText1Style.copyWith(
                          color: colors.grey1,
                        ),
                      ),
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
