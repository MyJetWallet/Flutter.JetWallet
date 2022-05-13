import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../screens/market/model/market_item_model.dart';
import '../../../../transaction_history/view/transaction_hisotry.dart';

// Todo: refactor
class IndexHistoryBlock extends HookWidget {
  const IndexHistoryBlock({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);

    return Container(
      height: 170,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        color: colors.grey5,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 19,
              top: 24,
            ),
            child: SStatsIcon(),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 46,
              top: 19,
            ),
            child: Text(
              intl.myStats,
              style: sSubtitle3Style,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 16,
                top: 16,
              ),
              child: InkWell(
                onTap: () {
                  TransactionHistory.push(
                    context: context,
                    assetName: marketItem.name,
                    assetSymbol: marketItem.symbol,
                  );
                },
                child: const SIndexHistoryIcon(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 63,
            ),
            child: Text(
              intl.avgCost,
              style: sBodyText2Style.copyWith(
                color: colors.grey1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 93,
            ),
            child: Text(
              intl.todaysReturn,
              style: sBodyText2Style.copyWith(
                color: colors.grey1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 123,
            ),
            child: Text(
              intl.totalReturn,
              style: sBodyText2Style.copyWith(
                color: colors.grey1,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 21,
                top: 61,
              ),
              child: Text(
                intl.comingSoon,
                style: sBodyText1Style,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 21,
                top: 91,
              ),
              child: Text(
                intl.comingSoon,
                style: sBodyText1Style,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 21,
                top: 121,
              ),
              child: Text(
                intl.comingSoon,
                style: sBodyText1Style,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
