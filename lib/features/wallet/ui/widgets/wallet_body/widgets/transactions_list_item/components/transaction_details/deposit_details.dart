import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class DepositDetails extends StatelessObserverWidget {
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
      sSignalRModules.currenciesList,
    ).firstWhere(
      (element) => element.symbol == transactionListItem.depositInfo?.feeAssetId,
      orElse: () => sSignalRModules.currenciesList.firstWhere((element) => element.symbol == 'EUR'),
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
                  SIconButton(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: transactionListItem.depositInfo!.txId ?? '',
                        ),
                      );

                      onCopyAction('Txid');
                    },
                    defaultIcon: const SCopyIcon(),
                    pressedIcon: const SCopyPressedIcon(),
                  ),
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
            fee: volumeFormat(
              symbol: feeAsset.symbol,
              accuracy: feeAsset.accuracy,
              decimal: transactionListItem.depositInfo?.feeAmount ?? Decimal.zero,
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
      sSignalRModules.currenciesList,
    ).firstWhere(
      (element) => element.symbol == transactionListItem.assetId,
    );

    return Column(
      children: [
        WhatToWhatConvertWidget(
          removeDefaultPaddings: true,
          isLoading: false,
          fromAssetIconUrl: paymentAsset.iconUrl,
          fromAssetDescription: paymentAsset.description,
          fromAssetValue: volumeFormat(
            symbol: paymentAsset.symbol,
            accuracy: paymentAsset.accuracy,
            decimal: transactionListItem.balanceChange,
          ),
          hasSecondAsset: false,
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
