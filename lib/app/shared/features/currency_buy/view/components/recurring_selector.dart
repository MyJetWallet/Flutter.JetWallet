import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';
import '../../../actions/action_recurring_buy/action_with_out_recurring_buy.dart';
import '../../../recurring/helper/recurring_buys_operation_name.dart';

class RecurringSelector extends HookWidget {
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
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);

    return Row(
      children: [
        const Spacer(),
        if (oneTimePurchaseOnly)
          Text(
            '${intl.recurringBuysType_oneTimePurchase} ${intl.only}',
            style: sSubtitle3Style.copyWith(
              color: colors.grey1,
            ),
          )
        else
          GestureDetector(
            onTap: () {
              showActionWithOutRecurringBuy(
                context: context,
                title:
                    '${intl.recurringSelector_withOutRecurringBuyTitle}?',
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
                        context,
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
