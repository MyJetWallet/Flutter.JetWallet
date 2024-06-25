import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/market/market_details/store/operation_history.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

import 'components/balance_action_buttons.dart';

class BalanceBlock extends StatelessWidget {
  const BalanceBlock({
    super.key,
    required this.marketItem,
  });

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    return Provider<OperationHistory>(
      create: (context) => OperationHistory(marketItem.symbol, null, null, null, false, null, null, null, null),
      builder: (context, child) => _BalanceBlockBody(
        marketItem: marketItem,
      ),
    );
  }
}

class _BalanceBlockBody extends StatelessObserverWidget {
  const _BalanceBlockBody({
    required this.marketItem,
  });

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 127,
      child: Column(
        children: [
          const SDivider(),
          const SpaceH16(),
          BalanceActionButtons(
            marketItem: marketItem,
          ),
          const SpaceH18(),
        ],
      ),
    );
  }
}
