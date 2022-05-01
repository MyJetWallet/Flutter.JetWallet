import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/signal_r/model/recurring_buys_model.dart';
import '../../../recurring/helper/recurring_buys_operation_name.dart';
import '../../../recurring/helper/recurring_buys_status_name.dart';
import '../../../recurring/notifier/recurring_buys_notipod.dart';
import '../../../wallet/helper/format_date_to_hm.dart';
import '../../../wallet/view/components/wallet_body/components/transactions_list_item/components/transaction_details/components/transaction_details_item.dart';
import '../../../wallet/view/components/wallet_body/components/transactions_list_item/components/transaction_details/components/transaction_details_value_text.dart';

class ActionRecurringInfoDetails extends HookWidget {
  const ActionRecurringInfoDetails({
    Key? key,
    required this.recurringItem,
  }) : super(key: key);

  final RecurringBuysModel recurringItem;

  @override
  Widget build(BuildContext context) {
    final notifier = useProvider(recurringBuysNotipod.notifier);

    return Column(
      children: [
        TransactionDetailsItem(
          text: 'Amount',
          value: TransactionDetailsValueText(
            text: notifier.price(
              asset: recurringItem.toAsset,
              amount: recurringItem.fromAmount!,
            ),
          ),
        ),
        const SpaceH14(),
        TransactionDetailsItem(
          text: 'Recurring buy',
          value: TransactionDetailsValueText(
            text: recurringItem.status == RecurringBuysStatus.paused
                ? 'Paused'
                : '${recurringBuysOperationName(
                    recurringItem.scheduleType,
                  )} - ${formatDateToHmFromDate(recurringItem.creationTime)}',
          ),
        ),
        if (recurringItem.nextExecution != null) ...[
          const SpaceH14(),
          TransactionDetailsItem(
            text: 'Next payment',
            value: TransactionDetailsValueText(
              text:
                  '${formatDateToDMYFromDate(recurringItem.nextExecution!)} - '
                  '${formatDateToHmFromDate(recurringItem.nextExecution!)}',
            ),
          ),
        ],
        const SpaceH14(),
        TransactionDetailsItem(
          text: 'Average',
          value: TransactionDetailsValueText(
            text: '${recurringItem.averagePrice}',
          ),
        ),
        const SpaceH34(),
      ],
    );
  }
}
