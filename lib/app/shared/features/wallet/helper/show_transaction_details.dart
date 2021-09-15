import 'package:flutter/cupertino.dart';

import '../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../components/basic_bottom_sheet/basic_bottom_sheet.dart';
import '../view/components/wallets_body/components/transactions_list_item/components/transaction_details/buy_sell_details.dart';
import '../view/components/wallets_body/components/transactions_list_item/components/transaction_details/components/common_transaction_details_block.dart';
import '../view/components/wallets_body/components/transactions_list_item/components/transaction_details/deposit_details.dart';
import '../view/components/wallets_body/components/transactions_list_item/components/transaction_details/receive_details.dart';
import '../view/components/wallets_body/components/transactions_list_item/components/transaction_details/transfer_details.dart';
import '../view/components/wallets_body/components/transactions_list_item/components/transaction_details/withdraw_details.dart';

void showTransactionDetails(
  BuildContext context,
  OperationHistoryItem transactionListItem,
) {
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
      if (transactionListItem.operationType == OperationType.withdraw) ...[
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
}
