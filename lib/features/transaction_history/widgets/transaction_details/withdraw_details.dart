import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/components/transaction_details_name_text.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../core/di/di.dart';
import '../../../app/store/app_store.dart';
import '../../../wallet/helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class WithdrawDetails extends StatelessWidget {
  const WithdrawDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: Column(
        children: [
          _WithdrawDetailsHeader(
            transactionListItem: transactionListItem,
          ),
          TransactionDetailsItem(
            text: intl.date,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          if (transactionListItem.withdrawalInfo!.txId != null) ...[
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.iban_send_history_transaction_id,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: shortTxhashFrom(
                      transactionListItem.withdrawalInfo!.txId ?? '',
                    ),
                  ),
                  const SpaceW10(),
                  HistoryCopyIcon(
                    transactionListItem.withdrawalInfo!.txId ?? '',
                  ),
                ],
              ),
            ),
          ],
          if (transactionListItem.withdrawalInfo!.toAddress != null) ...[
            const SpaceH18(),
            Row(
              children: [
                TransactionDetailsNameText(
                  text: intl.to1,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                Flexible(
                  child: TransactionDetailsValueText(
                    text: transactionListItem.withdrawalInfo!.toAddress ?? '',
                    textAlign: TextAlign.right,
                  ),
                ),
                const SpaceW8(),
                HistoryCopyIcon(
                  transactionListItem.withdrawalInfo!.toAddress ?? '',
                ),
              ],
            ),
          ],
          if (transactionListItem.withdrawalInfo!.network != null) ...[
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.cryptoDeposit_network,
              value: TransactionDetailsValueText(
                text: transactionListItem.withdrawalInfo!.network ?? '',
              ),
            ),
          ],
          const SpaceH18(),
          Builder(
            builder: (context) {
              final currency = currencyFrom(
                sSignalRModules.currenciesWithHiddenList,
                transactionListItem.withdrawalInfo!.feeAssetId ??
                    transactionListItem.withdrawalInfo!.withdrawalAssetId!,
              );

              return ProcessingFeeRowWidget(
                fee: currency.type == AssetType.crypto
                    ? transactionListItem.withdrawalInfo!.feeAmount.toFormatCount(
                        accuracy: currency.accuracy,
                        symbol: currency.symbol,
                      )
                    : transactionListItem.withdrawalInfo!.feeAmount.toFormatSum(
                        accuracy: currency.accuracy,
                        symbol: currency.symbol,
                      ),
              );
            },
          ),
          const SpaceH40(),
        ],
      ),
    );
  }
}

class _WithdrawDetailsHeader extends StatelessWidget {
  const _WithdrawDetailsHeader({
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final paymentAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.withdrawalInfo?.withdrawalAssetId ?? 'EUR'),
        )
        .first;

    final buyAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.withdrawalInfo?.receiveAsset ?? 'EUR'),
        )
        .first;

    return Column(
      children: [
        STransaction(
          removeDefaultPaddings: true,
          isLoading: false,
          fromAssetIconUrl: paymentAsset.iconUrl,
          fromAssetDescription: paymentAsset.description,
          fromAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${paymentAsset.symbol}'
              : (transactionListItem.withdrawalInfo?.withdrawalAmount.abs() ?? Decimal.zero).toFormatCount(
                  symbol: paymentAsset.symbol,
                  accuracy: paymentAsset.accuracy,
                ),
          toAssetIconUrl: buyAsset.iconUrl,
          toAssetDescription: buyAsset.description,
          toAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${buyAsset.symbol}'
              : (transactionListItem.withdrawalInfo?.receiveAmount?.abs() ?? Decimal.zero).toFormatCount(
                  symbol: buyAsset.symbol,
                  accuracy: buyAsset.accuracy,
                ),
          isError: transactionListItem.status == Status.declined,
          isSmallerVersion: true,
        ),
        const SizedBox(height: 24),
        SBadge(
          status: transactionListItem.status == Status.inProgress
              ? SBadgeStatus.primary
              : transactionListItem.status == Status.completed
                  ? SBadgeStatus.success
                  : SBadgeStatus.error,
          text: transactionDetailsStatusText(transactionListItem.status),
          isLoading: transactionListItem.status == Status.inProgress,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
