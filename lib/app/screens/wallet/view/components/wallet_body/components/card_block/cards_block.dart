import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../shared/helpers/contains_single_element.dart';
import '../../../../../../market/provider/market_items_pod.dart';
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
    final itemsWithBalance = assetsWithBalanceFrom(useProvider(marketItemsPod));

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 24.h,
          ),
          child: Row(
            children: [
              if (!containsSingleElement(itemsWithBalance) &&
                  currentPage > 0)
                const CardPart(),
              WalletCard(
                assetId: assetId,
              ),
              if (!containsSingleElement(itemsWithBalance) &&
                  currentPage == itemsWithBalance.length)
                const CardPart(),
            ],
          ),
        ),
        const SpaceH20(),
        if (!containsSingleElement(itemsWithBalance))
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final item in itemsWithBalance)
                Container(
                  height: 4.r,
                  width: 4.r,
                  margin: EdgeInsets.only(right: 6.w),
                  decoration: BoxDecoration(
                    color: itemsWithBalance.indexOf(item) == currentPage
                        ? Colors.black
                        : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        const SpaceH20(),
      ],
    );
  }
}
