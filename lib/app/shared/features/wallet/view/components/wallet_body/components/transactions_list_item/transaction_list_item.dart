import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
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
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 20.0,
                    maxHeight: 20.0,
                    minWidth: 20.0,
                    minHeight: 20.0,
                  ),
                  child: SvgPicture.asset(
                    _icon(transactionListItem.operationType),
                  ),
                ),
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

  String _icon(OperationType type) {
    switch (type) {
      case OperationType.deposit:
        return 'assets/images/deposit_icon.svg';
      case OperationType.withdraw:
        return 'assets/images/withdrawal_fee_icon.svg';
      case OperationType.transferByPhone:
        return 'assets/images/send_by_phone_icon.svg';
      case OperationType.receiveByPhone:
        return 'assets/images/receive_by_phone_icon.svg';
      case OperationType.buy:
        return 'assets/images/plus_icon.svg';
      case OperationType.sell:
        return 'assets/images/minus_icon.svg';
      case OperationType.paidInterestRate:
        return 'assets/images/paid_interest_rate_icon.svg';
      case OperationType.feeSharePayment:
        return 'assets/images/paid_interest_rate_icon.svg';
      case OperationType.withdrawalFee:
        return 'assets/images/withdrawal_fee_icon.svg';
      case OperationType.swap:
        return 'assets/images/swap_icon.svg';
      case OperationType.rewardPayment:
        return 'assets/images/reward_payment_icon.svg';
      case OperationType.unknown:
        return '';
    }
  }
}
