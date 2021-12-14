import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../shared/helpers/contains_single_element.dart';
import '../../../../../../../../screens/market/provider/market_items_pod.dart';
import '../../../../../helper/assets_with_balance_from.dart';
import 'components/card_part.dart';
import 'components/wallet_card.dart';

class CardBlock extends HookWidget {
  const CardBlock({
    Key? key,
    required this.currentPage,
    required this.assetId,
  }) : super(key: key);

  final int currentPage;
  final String assetId;

  @override
  Widget build(BuildContext context) {
    final itemsWithBalance = marketItemsWithBalanceFrom(
      useProvider(marketItemsPod),
      assetId,
    );

    return Column(
      children: [
        Row(
          children: [
            if (!containsSingleElement(itemsWithBalance) && currentPage > 0)
              const CardPart(
                left: true,
                width: 24,
              ),
            WalletCard(assetId: assetId, currentPage: currentPage),
            if (!containsSingleElement(itemsWithBalance) &&
                currentPage != itemsWithBalance.length - 1)
              const CardPart(
                left: false,
              ),
          ],
        ),
        const SpaceH36(),
      ],
    );
  }
}
