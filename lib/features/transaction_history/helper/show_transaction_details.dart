import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/features/transaction_history/helper/operation_name.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_item.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

void showTransactionDetails({
  required BuildContext context,
  required OperationHistoryItem transactionListItem,
  Function(dynamic)? then,
  TransactionItemSource source = TransactionItemSource.history,
}) {
  final currency = getIt<FormatService>().findCurrency(
    assetSymbol: transactionListItem.assetId,
    findInHideTerminalList: true,
  );

  final title = _transactionHeader(
    transactionListItem: transactionListItem,
    currency: currency,
    context: context,
    source: source,
  );

  showBasicBottomSheet(
    header: BasicBottomSheetHeaderWidget(
      title: title,
      withPadding: false,
    ),
    children: [
      TransactionItem(
        transactionListItem: transactionListItem,
        source: source,
      ),
    ],
    context: context,
  ).then((v) {
    then?.call(v);
  });
}

String _transactionHeader({
  required OperationHistoryItem transactionListItem,
  required CurrencyModel currency,
  required BuildContext context,
  TransactionItemSource source = TransactionItemSource.history,
}) {
  String title;
  if (transactionListItem.operationType == OperationType.simplexBuy) {
    title = '${operationName(OperationType.swapBuy, context, source: source)} '
        '${currency.description} - '
        '${operationName(transactionListItem.operationType, context, source: source)}';
  } else if (transactionListItem.operationType == OperationType.earningDeposit ||
      transactionListItem.operationType == OperationType.earningWithdrawal) {
    if (transactionListItem.earnInfo?.totalBalance != transactionListItem.balanceChange.abs() &&
        transactionListItem.operationType == OperationType.earningDeposit) {
      title = operationName(
        transactionListItem.operationType,
        context,
        isToppedUp: true,
        source: source,
      );
    }

    title = operationName(transactionListItem.operationType, context, source: source);
  } else if (transactionListItem.operationType == OperationType.swapBuy ||
      transactionListItem.operationType == OperationType.swapSell) {
    title = operationName(
      OperationType.swap,
      context,
      source: source,
    );
  } else if (transactionListItem.operationType == OperationType.sendGlobally) {
    title = operationName(
      OperationType.sendGlobally,
      context,
      source: source,
    );
  } else if (transactionListItem.operationType == OperationType.bankingAccountWithdrawal) {
    title = operationName(
      OperationType.bankingAccountWithdrawal,
      context,
      source: source,
    );
  } else if (transactionListItem.operationType == OperationType.giftSend) {
    title = operationName(
      OperationType.giftSend,
      context,
      source: source,
    );
  } else if (transactionListItem.operationType == OperationType.giftReceive) {
    title = operationName(
      OperationType.giftReceive,
      context,
      source: source,
    );
  } else if (transactionListItem.operationType == OperationType.bankingTransfer) {
    if (source == TransactionItemSource.history) {
      title = intl.transferDetails_transfer;
    } else if (transactionListItem.balanceChange > Decimal.zero) {
      title = intl.history_added_cash;
    } else {
      title = intl.history_withdrawn;
    }
  } else if (transactionListItem.operationType == OperationType.cardTransfer) {
    if (source == TransactionItemSource.history) {
      title = intl.transferDetails_transfer;
    } else if (transactionListItem.balanceChange > Decimal.zero) {
      title = intl.history_added_cash;
    } else {
      title = intl.history_withdrawn;
    }
  } else {
    title = operationName(
      transactionListItem.operationType,
      context,
      asset: transactionListItem.assetId,
      source: source,
    );
  }

  return title;
}
