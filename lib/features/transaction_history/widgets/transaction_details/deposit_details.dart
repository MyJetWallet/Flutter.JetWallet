import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_status_badge.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

import '../../../../core/di/di.dart';
import '../../../app/store/app_store.dart';
import '../../../wallet/helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class DepositDetails extends StatelessWidget {
  const DepositDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final feeAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    ).firstWhere(
      (element) => element.symbol == transactionListItem.depositInfo?.feeAssetId,
      orElse: () => sSignalRModules.currenciesWithHiddenList.firstWhere((element) => element.symbol == 'EUR'),
    );

    return SPaddingH24(
      child: Column(
        children: [
          _DepositDetailsHeader(
            transactionListItem: transactionListItem,
          ),
          TransactionDetailsItem(
            text: intl.date,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          if (transactionListItem.depositInfo?.txId != null) ...[
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.iban_send_history_transaction_id,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: shortTxhashFrom(
                      transactionListItem.depositInfo?.txId ?? '',
                    ),
                  ),
                  const SpaceW10(),
                  HistoryCopyIcon(transactionListItem.depositInfo?.txId ?? ''),
                ],
              ),
            ),
          ],
          if (transactionListItem.depositInfo?.network != null) ...[
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.cryptoDeposit_network,
              value: TransactionDetailsValueText(
                text: transactionListItem.depositInfo?.network ?? '',
              ),
            ),
          ],
          const SpaceH18(),
          ProcessingFeeRowWidget(
            fee: (transactionListItem.depositInfo?.feeAmount ?? Decimal.zero).toFormatCount(
              symbol: feeAsset.symbol,
              accuracy: feeAsset.accuracy,
            ),
          ),
          const SpaceH40(),
        ],
      ),
    );
  }
}

class _DepositDetailsHeader extends StatelessWidget {
  const _DepositDetailsHeader({
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final paymentAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    ).firstWhere(
      (element) => element.symbol == transactionListItem.assetId,
    );

    return Column(
      children: [
        STransaction(
          removeDefaultPaddings: true,
          isLoading: false,
          fromAssetIconUrl: paymentAsset.iconUrl,
          fromAssetDescription: paymentAsset.description,
          fromAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${paymentAsset.symbol}'
              : transactionListItem.balanceChange.toFormatCount(
                  symbol: paymentAsset.symbol,
                  accuracy: paymentAsset.accuracy,
                ),
          hasSecondAsset: false,
          isError: transactionListItem.status == Status.declined,
          isSmallerVersion: true,
        ),
        const SizedBox(height: 24),
        TransactionStatusBadge(status: transactionListItem.status),
        const SizedBox(height: 24),
      ],
    );
  }
}
