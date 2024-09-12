import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/widgets/top_movers_asset_item.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class TopMoversMarketSection extends StatelessWidget {
  const TopMoversMarketSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Observer(
      builder: (context) {
        final marketItems = [...sSignalRModules.getMarketPrices];

        marketItems.sort((a, b) => b.dayPercentChange.compareTo(a.dayPercentChange));

        final topMoverslist = marketItems.sublist(0, min(5, marketItems.length));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            STableHeader(
              title: intl.tom_mover_section_top_movers,
            ),
            SizedBox(
              height: 140,
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(
                    child: SizedBox(width: 24),
                  ),
                  SliverList.separated(
                    itemCount: topMoverslist.length,
                    itemBuilder: (context, index) {
                      return TopMoversAssetItem(
                        topMoverslist[index],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 8,
                      );
                    },
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(width: 24),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 32,
                left: 24,
                right: 24,
                bottom: 8,
              ),
              child: SDivider(
                height: 2,
                color: colors.gray2,
              ),
            ),
          ],
        );
      },
    );
  }
}
