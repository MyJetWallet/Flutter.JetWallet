import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/constants.dart';
import '../../../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../../../shared/providers/service_providers.dart';
import 'market_header_stats.dart';

class EmptyWatchlist extends HookWidget {
  const EmptyWatchlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final deviceSize = useProvider(deviceSizePod);

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
                      Text(
                        intl.emptyWatchlist_starAnAsset,
                        style: sBodyText1Style.copyWith(
                          color: colors.grey1,
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
