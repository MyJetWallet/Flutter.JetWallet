import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
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
    final colors = useProvider(sColorPod);

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
                _icon(transactionListItem.operationType),
                const SpaceW10(),
                TransactionListItemHeaderText(
                  text: operationName(transactionListItem.operationType),
                ),
                const Spacer(),
                TransactionListItemHeaderText(
                  text: '${transactionListItem.balanceChange} '
                      '${transactionListItem.assetId}',
                ),
              ],
            ),
            Row(
              children: [
                const SpaceW30(),
                TransactionListItemText(
                  text: '${formatDateToDMY(transactionListItem.timeStamp)} '
                      '- ${formatDateToHm(transactionListItem.timeStamp)}',
                  color: colors.grey2,
                ),
                const Spacer(),
                if (transactionListItem.operationType ==
                    OperationType.sell) ...[
                  TransactionListItemText(
                    text: 'For ${transactionListItem.swapInfo!.buyAmount} '
                        '${transactionListItem.swapInfo!.buyAssetId}',
                    color: colors.grey2,
                  ),
                ],
                if (transactionListItem.operationType == OperationType.buy) ...[
                  TransactionListItemText(
                    text: 'With ${transactionListItem.swapInfo!.sellAmount} '
                        '${transactionListItem.swapInfo!.sellAssetId}',
                    color: colors.grey2,
                  ),
                ]
              ],
            ),
            const SpaceH18(),
            if (!removeDivider) const SDivider(),
          ],
        ),
      ),
    );
  }

  Widget _icon(OperationType type) {
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
      case OperationType.unknown:
        return const SizedBox();
    }
  }
}
