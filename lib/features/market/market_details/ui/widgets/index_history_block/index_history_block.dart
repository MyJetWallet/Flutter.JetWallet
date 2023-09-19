import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:simple_kit/simple_kit.dart';

// Todo: refactor
class IndexHistoryBlock extends StatelessWidget {
  const IndexHistoryBlock({
    super.key,
    required this.marketItem,
  });

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

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
              intl.indexHistoryBlock_myStats,
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
                  sRouter.push(
                    TransactionHistoryRouter(
                      assetName: marketItem.name,
                      assetSymbol: marketItem.symbol,
                    ),
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
              intl.indexHistoryBlock_avgCost,
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
              intl.indexHistoryBlock_todaysReturn,
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
              intl.indexHistoryBlock_totalReturn,
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
                intl.indexHistoryBlock_comingSoon,
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
                intl.indexHistoryBlock_comingSoon,
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
                intl.indexHistoryBlock_comingSoon,
                style: sBodyText1Style,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
