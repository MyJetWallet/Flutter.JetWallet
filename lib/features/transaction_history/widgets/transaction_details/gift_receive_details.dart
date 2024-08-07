import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../core/di/di.dart';
import '../../../../utils/helpers/currency_from.dart';
import '../../../app/store/app_store.dart';
import '../../../wallet/helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class GiftReceiveDetails extends StatelessObserverWidget {
  const GiftReceiveDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final currency = currencyFrom(
      sSignalRModules.currenciesWithHiddenList,
      transactionListItem.assetId,
    );

    return SPaddingH24(
      child: Column(
        children: [
          _GiftReceiveDetailsHeader(
            transactionListItem: transactionListItem,
          ),
          TransactionDetailsItem(
            text: intl.date,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.gift_receive_history_from,
            value: Row(
              children: [
                TransactionDetailsValueText(
                  text: transactionListItem.giftReceiveInfo?.senderName ?? '',
                ),
              ],
            ),
          ),
          const SpaceH14(),
          ProcessingFeeRowWidget(
            fee: (transactionListItem.withdrawalInfo?.feeAmount ?? Decimal.zero).toFormatCount(
              accuracy: currency.accuracy,
              symbol: currency.symbol,
            ),
          ),
          const SpaceH42(),
        ],
      ),
    );
  }
}

class _GiftReceiveDetailsHeader extends StatelessWidget {
  const _GiftReceiveDetailsHeader({
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final paymentAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    ).firstWhere(
      (element) => element.symbol == (transactionListItem.assetId),
    );

    return Column(
      children: [
        WhatToWhatConvertWidget(
          removeDefaultPaddings: true,
          isLoading: false,
          fromAssetIconUrl: paymentAsset.iconUrl,
          fromAssetDescription: paymentAsset.description,
          fromAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${paymentAsset.symbol}'
              : transactionListItem.balanceChange.abs().toFormatCount(
                    symbol: paymentAsset.symbol,
                    accuracy: paymentAsset.accuracy,
                  ),
          isError: transactionListItem.status == Status.declined,
          hasSecondAsset: false,
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
