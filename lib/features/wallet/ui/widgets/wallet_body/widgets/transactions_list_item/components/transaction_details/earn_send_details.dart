import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../../../core/di/di.dart';
import '../../../../../../../../app/store/app_store.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class EarnSendDetails extends StatelessObserverWidget {
  const EarnSendDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final asset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    ).firstWhere(
      (element) => element.symbol == transactionListItem.assetId,
      orElse: () => CurrencyModel.empty(),
    );

    return SPaddingH24(
      child: Column(
        children: [
          _SellDetailsHeader(
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
            text: intl.earn_earn_account_id,
            value: Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: TransactionDetailsValueText(
                      text: transactionListItem.earnOperationInfo?.accountId ?? 'Account 1',
                      maxLines: 2,
                    ),
                  ),
                  const SpaceW10(),
                  HistoryCopyIcon(transactionListItem.earnOperationInfo?.accountId ?? 'Account 1'),
                ],
              ),
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
          Builder(
            builder: (context) {
              return ProcessingFeeRowWidget(
                fee: volumeFormat(
                  decimal: Decimal.zero,
                  accuracy: asset.accuracy,
                  symbol: asset.symbol,
                ),
              );
            },
          ),
          const SpaceH18(),
          const SpaceH40(),
        ],
      ),
    );
  }
}

class _SellDetailsHeader extends StatelessWidget {
  const _SellDetailsHeader({
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final asset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    ).firstWhere(
      (element) => element.symbol == transactionListItem.assetId,
      orElse: () => CurrencyModel.empty(),
    );

    return Column(
      children: [
        WhatToWhatConvertWidget(
          removeDefaultPaddings: true,
          isLoading: false,
          fromAssetIconUrl: asset.iconUrl,
          fromAssetDescription: intl.earn_crypto_wallet,
          fromAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${asset.symbol}'
              : volumeFormat(
                  symbol: asset.symbol,
                  accuracy: asset.accuracy,
                  decimal: transactionListItem.earnOperationInfo?.amount?.abs() ?? Decimal.zero,
                ),
          toAssetIconUrl: asset.iconUrl,
          toAssetDescription: intl.earn_earn,
          toAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${asset.symbol}'
              : volumeFormat(
                  symbol: asset.symbol,
                  accuracy: asset.accuracy,
                  decimal: transactionListItem.earnOperationInfo?.amount?.abs() ?? Decimal.zero,
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
