import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
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

class AddCashDetails extends StatelessObserverWidget {
  const AddCashDetails({
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
          _AddCashDetailsHeader(
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
            text: intl.transactionDetails_fromBankAccount,
            value: Row(
              children: [
                TransactionDetailsValueText(
                  text: shortTxhashFrom(
                    transactionListItem.ibanDepositInfo?.fromIban ?? '',
                  ),
                ),
                const SpaceW10(),
                HistoryCopyIcon(
                  transactionListItem.ibanDepositInfo?.fromIban ?? '',
                ),
              ],
            ),
          ),
          const SpaceH18(),
          Builder(
            builder: (context) {
              final currency = currencyFrom(
                sSignalRModules.currenciesWithHiddenList,
                transactionListItem.ibanDepositInfo?.paymentFeeAssetId ??
                    transactionListItem.ibanDepositInfo?.processingFeeAssetId ??
                    '',
              );

              return PaymentFeeRowWidget(
                fee: (transactionListItem.ibanDepositInfo?.paymentFeeAmount ?? Decimal.zero).toFormatCount(
                  accuracy: currency.accuracy,
                  symbol: currency.symbol,
                ),
              );
            },
          ),
          const SpaceH18(),
          Builder(
            builder: (context) {
              final currency = currencyFrom(
                sSignalRModules.currenciesWithHiddenList,
                transactionListItem.ibanDepositInfo?.processingFeeAssetId ??
                    transactionListItem.ibanDepositInfo?.paymentFeeAssetId ??
                    '',
              );

              return ProcessingFeeRowWidget(
                fee: (transactionListItem.ibanDepositInfo?.processingFeeAmount ?? Decimal.zero).toFormatCount(
                  accuracy: currency.accuracy,
                  symbol: currency.symbol,
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

class _AddCashDetailsHeader extends StatelessWidget {
  const _AddCashDetailsHeader({
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final paymentAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    )
        .where(
          (element) => element.symbol == transactionListItem.assetId,
        )
        .first;

    return Column(
      children: [
        WhatToWhatConvertWidget(
          removeDefaultPaddings: true,
          isLoading: false,
          fromAssetIconUrl: paymentAsset.iconUrl,
          fromAssetDescription: transactionListItem.ibanDepositInfo?.accountLabel ?? '',
          fromAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${paymentAsset.symbol}'
              : transactionListItem.balanceChange.abs().toFormatCount(
                    symbol: paymentAsset.symbol,
                    accuracy: paymentAsset.accuracy,
                  ),
          fromAssetCustomIcon: Assets.svg.other.medium.bankAccount.simpleSvg(
            width: 32,
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

Widget getCardIcon(String? network) {
  switch (network?.toUpperCase()) {
    case 'VISA':
      return const SVisaCardIcon(
        width: 40,
        height: 25,
      );
    case 'MASTER CARD':
      return const SMasterCardIcon(
        width: 40,
        height: 25,
      );
    default:
      return const SActionDepositIcon();
  }
}
