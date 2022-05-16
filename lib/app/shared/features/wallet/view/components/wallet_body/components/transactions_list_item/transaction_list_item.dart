import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../../helpers/currency_from.dart';
import '../../../../../../../helpers/formatting/formatting.dart';
import '../../../../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../../../helper/format_date_to_hm.dart';
import '../../../../../helper/operation_name.dart';
import '../../../../../helper/show_transaction_details.dart';
import 'components/transaction_list_item_header_text.dart';
import 'components/transaction_list_item_text.dart';

class TransactionListItem extends HookWidget {
  const TransactionListItem({
    Key? key,
    this.removeDivider = false,
    required this.transactionListItem,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final bool removeDivider;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final currencies = context.read(currenciesPod);
    final currency = currencyFrom(
      currencies,
      transactionListItem.assetId,
    );

    return InkWell(
      onTap: () => showTransactionDetails(
        context,
        transactionListItem,
      ),
      child: SizedBox(
        height: 80,
        child: Column(
          children: [
            const SpaceH12(),
            Row(
              children: [
                _iconFrom(transactionListItem.operationType),
                const SpaceW10(),
                Expanded(
                  child: TransactionListItemHeaderText(
                    text: _transactionItemTitle(
                      transactionListItem,
                      context,
                    ),
                    color: transactionListItem.status == Status.declined
                        ? colors.red
                        : colors.black,
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 220,
                    minWidth: 100,
                  ),
                  child: TransactionListItemHeaderText(
                    text: volumeFormat(
                      prefix: currency.prefixSymbol,
                      decimal: transactionListItem.balanceChange,
                      accuracy: currency.accuracy,
                      symbol: currency.symbol,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const SpaceW30(),
                if (transactionListItem.status != Status.inProgress)
                  TransactionListItemText(
                    text: '${formatDateToDMY(transactionListItem.timeStamp)} '
                        '- ${formatDateToHm(transactionListItem.timeStamp)}',
                    color: colors.grey2,
                  ),
                if (transactionListItem.status == Status.inProgress)
                  TransactionListItemText(
                    text: '${intl.balanceInProcess_text1}...',
                    color: colors.grey2,
                  ),
                const Spacer(),
                if (transactionListItem.operationType == OperationType.sell)
                  TransactionListItemText(
                    text: '${intl.forText} ${volumeFormat(
                      prefix: currency.prefixSymbol,
                      decimal: transactionListItem.swapInfo!.buyAmount,
                      accuracy: currency.accuracy,
                      symbol: transactionListItem.swapInfo!.buyAssetId,
                    )}',
                    color: colors.grey2,
                  ),
                if (transactionListItem.operationType == OperationType.buy)
                  TransactionListItemText(
                    text: '${intl.withText} ${volumeFormat(
                      prefix: currency.prefixSymbol,
                      decimal: transactionListItem.swapInfo!.sellAmount,
                      accuracy: currency.accuracy,
                      symbol: transactionListItem.swapInfo!.sellAssetId,
                    )}',
                    color: colors.grey2,
                  ),
                if (transactionListItem.operationType ==
                    OperationType.simplexBuy)
                  TransactionListItemText(
                    text: '${intl.withText} '
                        '\$${transactionListItem.buyInfo!.sellAmount}',
                    color: colors.grey2,
                  ),
                if (transactionListItem.operationType ==
                    OperationType.recurringBuy)
                  TransactionListItemText(
                    text: '${intl.withText} ${volumeFormat(
                      prefix: currency.prefixSymbol,
                      decimal: transactionListItem.recurringBuyInfo!.sellAmount,
                      accuracy: currency.accuracy,
                      symbol:
                          transactionListItem.recurringBuyInfo!.sellAssetId!,
                    )}',
                    color: colors.grey2,
                  ),
              ],
            ),
            const SpaceH18(),
            if (!removeDivider) const SDivider(),
          ],
        ),
      ),
    );
  }

  String _transactionItemTitle(
    OperationHistoryItem transactionListItem,
    BuildContext context,
  ) {
    if (transactionListItem.operationType == OperationType.simplexBuy) {
      return '${operationName(
        OperationType.buy,
        context,
      )}'
          ' ${transactionListItem.assetId} - '
          '${operationName(
        transactionListItem.operationType,
        context,
      )}';
    } else if (transactionListItem.operationType ==
        OperationType.recurringBuy) {
      return '${transactionListItem.recurringBuyInfo!.scheduleType} '
          '${operationName(
        transactionListItem.operationType,
        context,
      )}';
    } else {
      return operationName(
        transactionListItem.operationType,
        context,
      );
    }
  }

  Widget _iconFrom(OperationType type) {
    switch (type) {
      case OperationType.deposit:
        return const SDepositIcon();
      case OperationType.withdraw:
        return const SWithdrawalFeeIcon();
      case OperationType.transferByPhone:
        return const SSendByPhoneIcon();
      case OperationType.receiveByPhone:
        return const SReceiveByPhoneIcon();
      case OperationType.buy:
        return const SPlusIcon();
      case OperationType.sell:
        return const SMinusIcon();
      case OperationType.paidInterestRate:
        return const SPaidInterestRateIcon();
      case OperationType.feeSharePayment:
        return const SPaidInterestRateIcon();
      case OperationType.withdrawalFee:
        return const SWithdrawalFeeIcon();
      case OperationType.swap:
        return const SSwapIcon();
      case OperationType.rewardPayment:
        return const SRewardPaymentIcon();
      case OperationType.simplexBuy:
        return const SDepositIcon();
      case OperationType.recurringBuy:
        return const SPlusIcon();
      case OperationType.unknown:
        return const SizedBox();
    }
  }
}
