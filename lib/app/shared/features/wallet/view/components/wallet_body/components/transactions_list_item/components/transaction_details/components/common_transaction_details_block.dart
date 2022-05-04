import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../../../models/currency_model.dart';
import '../../../../../../../../../../providers/currencies_with_hidden_pod/currencies_pod.dart';
import '../../../../../../../../../market_details/helper/currency_from_all.dart';
import '../../../../../../../../helper/format_date_to_hm.dart';
import '../../../../../../../../helper/is_operation_support_copy.dart';
import '../../../../../../../../helper/operation_name.dart';

class CommonTransactionDetailsBlock extends HookWidget {
  const CommonTransactionDetailsBlock({
    Key? key,
    required this.transactionListItem,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final currency = currencyFromAll(
      useProvider(currenciesWithHiddenPod),
      transactionListItem.assetId,
    );

    return Column(
      children: [
        Text(
          _transactionHeader(transactionListItem, currency),
          style: sTextH5Style,
        ),
        const SpaceH67(),
        Text(
          '${operationAmount(transactionListItem)} ${currency.symbol}',
          style: sTextH1Style,
        ),
        if (transactionListItem.status == Status.completed)
          Text(
            convertToUsd(
              transactionListItem.assetPriceInUsd,
              operationAmount(transactionListItem),
            ),
            style: sBodyText2Style.copyWith(
              color: colors.grey2,
            ),
          ),
        Text(
          '${formatDateToDMY(transactionListItem.timeStamp)} '
          '- ${formatDateToHm(transactionListItem.timeStamp)}',
          style: sBodyText2Style.copyWith(
            color: colors.grey2,
          ),
        ),
        if (isOperationSupportCopy(transactionListItem))
          const SpaceH8()
        else
          const SpaceH72(),
      ],
    );
  }

  String _transactionHeader(
    OperationHistoryItem transactionListItem,
    CurrencyModel currency,
  ) {
    if (transactionListItem.operationType == OperationType.simplexBuy) {
      return '${operationName(OperationType.buy)} '
          '${currency.description} - '
          '${operationName(transactionListItem.operationType)}';
    } else if (transactionListItem.operationType ==
        OperationType.recurringBuy) {
      return '${transactionListItem.recurringBuyInfo!.scheduleType} '
          '${operationName(transactionListItem.operationType)}';
    } else {
      return '${operationName(transactionListItem.operationType)} '
          '${currency.description}';
    }
  }

  String convertToUsd(Decimal assetPriceInUsd, Decimal balance) {
    final usd = assetPriceInUsd * balance;
    if (usd < Decimal.zero) {
      final plusValue = usd.toString().split('-').last;
      return '≈ \$${Decimal.parse(plusValue).toStringAsFixed(2)}';
    }
    return '≈ \$${usd.toStringAsFixed(2)}';
  }

  Decimal operationAmount(OperationHistoryItem transactionListItem) {
    if (transactionListItem.operationType == OperationType.withdraw) {
      return transactionListItem.withdrawalInfo!.withdrawalAmount;
    }
    return transactionListItem.balanceChange;
  }
}
