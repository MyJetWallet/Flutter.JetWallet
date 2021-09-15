import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../shared/components/basic_bottom_sheet/basic_bottom_sheet.dart';
import '../../../../../helper/operation_name.dart';
import '../../../../../provider/wallet_hidden_stpod.dart';
import 'components/transaction_details/buy_sell_details.dart';
import 'components/transaction_details/components/common_transaction_details_block.dart';
import 'components/transaction_details/deposit_details.dart';
import 'components/transaction_details/receive_details.dart';
import 'components/transaction_details/transfer_details.dart';
import 'components/transaction_details/withdraw_details.dart';
import 'components/transaction_list_item_body_text.dart';
import 'components/transaction_list_item_header_text.dart';

class TransactionListItem extends HookWidget {
  const TransactionListItem({
    Key? key,
    required this.transactionListItem,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final hidden = useProvider(walletHiddenStPod);

    return InkWell(
      onTap: () {
        showBasicBottomSheet(
          scrollable: true,
          children: [
            CommonTransactionDetailsBlock(
              transactionListItem: transactionListItem,
            ),
            if (transactionListItem.operationType == OperationType.deposit) ...[
              DepositDetails(
                transactionListItem: transactionListItem,
              ),
            ],
            if (transactionListItem.operationType ==
                OperationType.withdraw) ...[
              WithdrawDetails(
                transactionListItem: transactionListItem,
              ),
            ],
            if (transactionListItem.operationType == OperationType.buy ||
                transactionListItem.operationType == OperationType.sell) ...[
              BuySellDetails(
                transactionListItem: transactionListItem,
              ),
            ],
            if (transactionListItem.operationType ==
                OperationType.transferByPhone) ...[
              TransferDetails(
                transactionListItem: transactionListItem,
              ),
            ],
            if (transactionListItem.operationType ==
                OperationType.receiveByPhone) ...[
              ReceiveDetails(
                transactionListItem: transactionListItem,
              ),
            ],
          ],
          context: context,
        );
      },
      child: SizedBox(
        height: 80.h,
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  _icon(transactionListItem.operationType),
                  size: 20.r,
                ),
                const SpaceW10(),
                TransactionListItemHeaderText(
                  text: operationName(transactionListItem.operationType),
                ),
                const Spacer(),
                TransactionListItemHeaderText(
                  text:
                      '${hidden.state
                          ? '???'
                          : transactionListItem.balanceChange} '
                          '${transactionListItem.assetId}',
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 20.r,
                ),
                const SpaceW10(),
                Text(
                  DateFormat('Hm').format(
                    DateTime.parse('${transactionListItem.timeStamp}Z')
                        .toLocal(),
                  ),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.sp,
                  ),
                ),
                const Spacer(),
                if (transactionListItem.operationType ==
                    OperationType.sell) ...[
                  TransactionListItemBodyText(
                    text:
                        'For ${'${hidden.state
                            ? '???'
                            : transactionListItem.swapInfo!.buyAmount}'} '
                        '${transactionListItem.swapInfo!.buyAssetId}',
                  ),
                ],
                if (transactionListItem.operationType == OperationType.buy) ...[
                  TransactionListItemBodyText(
                    text:
                        'With ${'${hidden.state
                            ? '???'
                            : transactionListItem.swapInfo!.sellAmount}'} '
                        '${transactionListItem.swapInfo!.sellAssetId}',
                  ),
                ]
              ],
            ),
            const SpaceH10(),
            const Divider(),
          ],
        ),
      ),
    );
  }

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
      case OperationType.withdrawalFee:
      case OperationType.swap:
      case OperationType.unknown:
        return FontAwesomeIcons.question;
    }
  }
}
