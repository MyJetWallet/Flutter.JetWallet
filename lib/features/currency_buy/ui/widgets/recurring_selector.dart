import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/reccurring/helper/recurring_buys_operation_name.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';

import '../../../actions/action_recurring_buy/action_with_out_recurring_buy.dart';

class RecurringSelector extends StatelessWidget {
  const RecurringSelector({
    Key? key,
    this.oneTimePurchaseOnly = false,
    required this.currentSelection,
    required this.onSelect,
  }) : super(key: key);

  final bool oneTimePurchaseOnly;
  final RecurringBuysType currentSelection;
  final void Function(RecurringBuysType) onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Row(
      children: [
        const Spacer(),
        if (oneTimePurchaseOnly)
          Text(
            '${intl.recurringBuysType_oneTimePurchase}'
            ' ${intl.recurringBuysType_only}',
            style: sSubtitle3Style.copyWith(
              color: colors.grey1,
            ),
          )
        else
          GestureDetector(
            onTap: () {
              showActionWithoutRecurringBuy(
                context: context,
                title: '${intl.recurringSelector_withOutRecurringBuyTitle}?',
                showOneTimePurchase: true,
                currentType: currentSelection,
                onItemTap: onSelect,
              );
            },
            child: Container(
              height: 28,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: colors.blue,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                children: [
                  Baseline(
                    baseline: 14,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      recurringBuysOperationName(
                        currentSelection,
                      ),
                      style: sSubtitle3Style.copyWith(
                        color: colors.white,
                      ),
                    ),
                  ),
                  const SpaceW8(),
                  SAngleDownIcon(
                    color: colors.white,
                  ),
                ],
              ),
            ),
          ),
        const Spacer(),
      ],
    );
  }
}
