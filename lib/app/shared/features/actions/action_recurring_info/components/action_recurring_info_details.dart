import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/recurring_buys_model.dart';

import '../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../market_details/helper/currency_from.dart';
import '../../../recurring/helper/recurring_buys_operation_name.dart';
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
    final currencies = context.read(currenciesPod);
    final baseCurrency = useProvider(baseCurrencyPod);

    final sellCurrency = currencyFrom(
      currencies,
      recurringItem.fromAsset,
    );

    return Column(
      children: [
        TransactionDetailsItem(
          text: 'Amount',
          value: TransactionDetailsValueText(
            text: '${sellCurrency.prefixSymbol ?? ''}'
                '${recurringItem.fromAmount} '
                '${sellCurrency.prefixSymbol != null ? '' : sellCurrency.symbol}',
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
          text: 'Average price',
          value: TransactionDetailsValueText(
            text: notifier.price(
              asset: baseCurrency.symbol,
              amount: double.parse(
                '${recurringItem.averagePrice}',
              ),
            ),
          ),
        ),
        const SpaceH34(),
      ],
    );
  }
}
