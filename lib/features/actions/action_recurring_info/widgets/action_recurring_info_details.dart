import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/reccurring/helper/recurring_buys_operation_name.dart';
import 'package:jetwallet/features/reccurring/store/recurring_buys_store.dart';
import 'package:jetwallet/features/wallet/helper/format_date_to_hm.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/transaction_details_item.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/transaction_details_value_text.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_model.dart';

class ActionRecurringInfoDetails extends StatelessObserverWidget {
  const ActionRecurringInfoDetails({
    super.key,
    required this.recurringItem,
  });

  final RecurringBuysModel recurringItem;

  @override
  Widget build(BuildContext context) {
    final notifier = getIt.get<RecurringBuysStore>();
    final currencies = sSignalRModules.currenciesList;
    final baseCurrency = sSignalRModules.baseCurrency;

    final sellCurrency = currencyFrom(
      currencies,
      recurringItem.fromAsset,
    );

    return Column(
      children: [
        TransactionDetailsItem(
          text: intl.actionReccuringInfoDetails_amount,
          value: TransactionDetailsValueText(
            text: volumeFormat(
              prefix: sellCurrency.prefixSymbol,
              decimal: Decimal.parse(
                recurringItem.fromAmount.toString(),
              ),
              accuracy: sellCurrency.accuracy,
              symbol: sellCurrency.symbol,
            ),
          ),
        ),
        const SpaceH14(),
        TransactionDetailsItem(
          text: intl.account_recurringBuy,
          value: TransactionDetailsValueText(
            text: recurringItem.status == RecurringBuysStatus.paused
                ? intl.actionRecurringInfoDetails_paused
                : '${recurringBuysOperationName(
                    recurringItem.scheduleType,
                  )} - ${formatDateToHmFromDate(recurringItem.creationTime)}',
          ),
        ),
        if (recurringItem.nextExecution != null) ...[
          const SpaceH14(),
          TransactionDetailsItem(
            text: intl.actionRecurringInfoDetails_nextPayment,
            value: TransactionDetailsValueText(
              text:
                  '${formatDateToDMYFromDate(recurringItem.nextExecution!)} - '
                  '${formatDateToHmFromDate(recurringItem.nextExecution!)}',
            ),
          ),
        ],
        const SpaceH14(),
        TransactionDetailsItem(
          text: intl.actionRecurringInfoDetails_averagePrice,
          value: TransactionDetailsValueText(
            text: notifier.price(
              asset: baseCurrency.symbol,
              amount: double.parse(
                '${recurringItem.avgPrice}',
              ),
            ),
          ),
        ),
        const SpaceH34(),
      ],
    );
  }
}
