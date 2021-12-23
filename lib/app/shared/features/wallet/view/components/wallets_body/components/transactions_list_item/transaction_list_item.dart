import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../helper/format_date_to_hm.dart';
import '../../../../../helper/operation_name.dart';
import '../../../../../helper/show_transaction_details.dart';
import '../../../../../provider/wallet_hidden_stpod.dart';
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
    final hidden = useProvider(walletHiddenStPod);
    var color = colors.green;

    if (transactionListItem.balanceChange.isNegative) {
      color = colors.red;
    }

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
                Icon(
                  _icon(transactionListItem.operationType),
                  size: 20,
                  color: color,
                ),
                const SpaceW10(),
                TransactionListItemHeaderText(
                  text: operationName(transactionListItem.operationType),
                ),
                const Spacer(),
                TransactionListItemHeaderText(
                  text: _balanceChange(hidden.state),
                ),
              ],
            ),
            Row(
              children: [
                const SpaceW30(),
                TransactionListItemText(
                  text: '${formatDateToDMY(transactionListItem.timeStamp)} '
                      '- ${formatDateToHm(transactionListItem.timeStamp)}',
                  color: colors.grey1,
                ),
                const Spacer(),
                if (transactionListItem.operationType ==
                    OperationType.sell) ...[
                  TransactionListItemText(
                    text: _sellAmount(hidden.state),
                    color: colors.grey1,
                  ),
                ],
                if (transactionListItem.operationType == OperationType.buy) ...[
                  TransactionListItemText(
                    text: _buyAmount(hidden.state),
                    color: colors.grey1,
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

  String _buyAmount(bool hidden) =>
      'With ${'${hidden ? '???' : transactionListItem.swapInfo!.sellAmount}'} '
      '${transactionListItem.swapInfo!.sellAssetId}';

  String _sellAmount(bool hidden) =>
      'For ${'${hidden ? '???' : transactionListItem.swapInfo!.buyAmount}'} '
      '${transactionListItem.swapInfo!.buyAssetId}';

  String _balanceChange(bool hidden) =>
      '${hidden ? '???' : transactionListItem.balanceChange} '
      '${transactionListItem.assetId}';

  IconData _icon(OperationType type) {
    switch (type) {
      case OperationType.deposit:
        return FontAwesomeIcons.creditCard;
      case OperationType.withdraw:
        return Icons.arrow_forward;
      case OperationType.transferByPhone:
        return Icons.arrow_upward;
      case OperationType.receiveByPhone:
        return Icons.arrow_downward;
      case OperationType.buy:
        return FontAwesomeIcons.plus;
      case OperationType.sell:
        return FontAwesomeIcons.minus;
      case OperationType.paidInterestRate:
      case OperationType.transfer:
      case OperationType.feeSharePayment:
      case OperationType.withdrawalFee:
      case OperationType.swap:
      case OperationType.rewardPayment:
      case OperationType.unknown:
        return FontAwesomeIcons.question;
    }
  }
}
