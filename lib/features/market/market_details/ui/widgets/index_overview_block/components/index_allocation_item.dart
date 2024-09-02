import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/wallet/helper/market_item_from.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/indices_model.dart';

class IndexAllocationItem extends StatelessObserverWidget {
  const IndexAllocationItem({
    super.key,
    required this.basketAssetModel,
  });

  final BasketAssetModel basketAssetModel;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final marketItem = marketItemFrom(
      sSignalRModules.marketItems,
      basketAssetModel.symbol,
    );
    final targetRebalanceWeightPercent = (basketAssetModel.targetRebalanceWeight * Decimal.parse('100')).toBigInt();

    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: NetworkIconWidget(
              marketItem.iconUrl,
            ),
          ),
          const SpaceW10(),
          SBaselineChild(
            baseline: 26,
            child: Text(
              '${marketItem.name} (${marketItem.symbol})',
              style: sBodyText1Style.copyWith(color: colors.grey1),
            ),
          ),
          const Spacer(),
          SBaselineChild(
            baseline: 26,
            child: Text(
              '$targetRebalanceWeightPercent%',
              style: sBodyText1Style.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
