import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/market/store/market_filter_store.dart';
import 'package:simple_kit/simple_kit.dart';

import 'market_gainers.dart';
import 'market_losers.dart';

void showCryptoFilterModalSheet(
  BuildContext context,
  MarketFilterStore filterStore,
) {
  final gainers = getMarketGainers();
  final losers = getMarketLosers();
  final listOfFilters = ['all'];
  if (gainers.isNotEmpty) {
    listOfFilters.add('gainers');
  }
  if (losers.isNotEmpty) {
    listOfFilters.add('losers');
  }


  sShowBasicModalBottomSheet(
    onDissmis: () {},
    context: context,
    horizontalPinnedPadding: 0.0,
    pinned: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Baseline(
              baseline: 20.0,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                intl.market_nft_show,
                style: sTextH4Style,
                maxLines: 2,
              ),
            ),
          ),
          SIconButton(
            onTap: () {
              Navigator.pop(context);
            },
            defaultIcon: const SEraseIcon(),
            pressedIcon: const SErasePressedIcon(),
          ),
        ],
      ),
    ),
    children: [
      Observer(
        builder: (context) {
          return Column(
            children: [
              Column(
                children: listOfFilters.map((e) {
                  final ind = listOfFilters.indexOf(e);

                  return filterItem(
                    context,
                    e,
                    filterStore: filterStore,
                    isLast: listOfFilters.length - 1 == ind,
                    isSelected: filterStore.activeFilter == e,
                  );
                }).toList(),
              ),
              const SpaceH40(),
            ],
          );
        },
      ),
    ],
  );
}

Widget filterItem(
  BuildContext context,
  String item, {
  required MarketFilterStore filterStore,
  bool isLast = false,
  bool isSelected = false,
}) {
  final colors = sKit.colors;

  return InkWell(
    onTap: () {
      filterStore.cryptoFilterChange(item);
      Navigator.pop(context);
    },
    child: SPaddingH24(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH18(),
          Row(
            children: [
              Baseline(
                baseline: 24,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  nameFilterByType(item),
                  style: sSubtitle2Style.copyWith(
                    color: isSelected ? colors.blue : colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SpaceH22(),
          if (!isLast) ...[
            const SDivider(),
          ],
        ],
      ),
    ),
  );
}

String nameFilterByType (String type) {
  switch (type) {
    case 'all':
      return intl.market_all;
    case 'gainers':
      return intl.market_bottomTabLabel4;
    case 'losers':
      return intl.market_bottomTabLabel5;
    default:
      return '';
  }
}
