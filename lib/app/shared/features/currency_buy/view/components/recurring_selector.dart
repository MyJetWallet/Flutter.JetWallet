import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../models/currency_model.dart';
import '../../../actions/action_recurring_buy/action_with_out_recurring_buy.dart';
import '../../../recurring/helper/recurring_buys_operation_name.dart';
import '../../notifier/currency_buy_notifier/currency_buy_notipod.dart';

class RecurringSelector extends HookWidget {
  const RecurringSelector({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final state = useProvider(currencyBuyNotipod(currency));
    final notifier = useProvider(currencyBuyNotipod(currency).notifier);

    return Row(
      children: [
        const Spacer(),
        GestureDetector(
          onTap: () {
            showActionWithoutRecurringBuy(
              context: context,
              title: 'Repeat this purchase?',
              showOneTimePurchase: true,
              currentType: state.recurringBuyType,
              onItemTap: (recurringType) {
                notifier.updateRecurringBuyType(recurringType);
                Navigator.of(context).pop();
              },
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
                      state.recurringBuyType,
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
