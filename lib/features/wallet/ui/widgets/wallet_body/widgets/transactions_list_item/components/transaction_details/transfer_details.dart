import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../../../core/di/di.dart';
import '../../../../../../../../app/store/app_store.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class TransferDetails extends StatelessObserverWidget {
  const TransferDetails({
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
          _TransferDetailsHeader(
            transactionListItem: transactionListItem,
          ),
          TransactionDetailsItem(
            text: intl.send_globally_date,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.iban_send_history_transaction_id,
            value: Row(
              children: [
                TransactionDetailsValueText(
                  text: shortTxhashFrom(transactionListItem.operationId),
                ),
                const SpaceW10(),
                HistoryCopyIcon(transactionListItem.operationId),
              ],
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.from,
            value: Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 10),
                  Flexible(
                    child: TransactionDetailsValueText(
                      text: transactionListItem.ibanTransferInfo?.fromAccountLabel ?? 'Account 1',
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.to1,
            value: Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 10),
                  Flexible(
                    child: TransactionDetailsValueText(
                      text: transactionListItem.ibanTransferInfo?.toAccountLabel ?? 'Account 1',
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SpaceH18(),
          PaymentFeeRowWidget(
            fee: (transactionListItem.ibanTransferInfo?.paymentFeeAmount ?? Decimal.zero).toFormatCount(
              symbol: transactionListItem.ibanTransferInfo?.paymentFeeAssetId ?? 'EUR',
            ),
          ),
          const SpaceH18(),
          ProcessingFeeRowWidget(
            fee: (transactionListItem.ibanTransferInfo?.simpleFeeAmount ?? Decimal.zero).toFormatCount(
              symbol: transactionListItem.ibanTransferInfo?.simpleFeeAssetId ?? 'EUR',
            ),
          ),
          const SpaceH18(),
          const SpaceH40(),
        ],
      ),
    );
  }
}

class _TransferDetailsHeader extends StatelessWidget {
  const _TransferDetailsHeader({
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final euroAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.ibanTransferInfo?.withdrawalAssetId ?? 'EUR'),
        )
        .first;

    return Column(
      children: [
        WhatToWhatConvertWidget(
          removeDefaultPaddings: true,
          isLoading: false,
          fromAssetIconUrl: euroAsset.iconUrl,
          fromAssetDescription: transactionListItem.ibanTransferInfo?.fromAccountLabel ?? 'Account 1',
          fromAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${euroAsset.symbol}'
              : (transactionListItem.ibanTransferInfo?.withdrawalAmount?.abs() ?? Decimal.zero).toFormatCount(
                  symbol: euroAsset.symbol,
                  accuracy: euroAsset.accuracy,
                ),
          fromAssetCustomIcon: transactionListItem.ibanTransferInfo?.fromAccountType == IbanAccountType.bankCard
              ? Assets.svg.assets.fiat.card.simpleSvg(
                  width: 32,
                )
              : Assets.svg.other.medium.bankAccount.simpleSvg(
                  width: 32,
                ),
          toAssetIconUrl: euroAsset.iconUrl,
          toAssetDescription: transactionListItem.ibanTransferInfo?.toAccountLabel ?? 'Account 1',
          toAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${euroAsset.symbol}'
              : (transactionListItem.ibanTransferInfo?.receiveAmount?.abs() ?? Decimal.zero).toFormatCount(
                  symbol: euroAsset.symbol,
                  accuracy: euroAsset.accuracy,
                ),
          toAssetCustomIcon: transactionListItem.ibanTransferInfo?.toAccountType == IbanAccountType.bankCard
              ? Assets.svg.assets.fiat.card.simpleSvg(
                  width: 32,
                )
              : Assets.svg.other.medium.bankAccount.simpleSvg(
                  width: 32,
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
