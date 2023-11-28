import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
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

class SendGloballyDetails extends StatelessObserverWidget {
  const SendGloballyDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      transactionListItem.withdrawalInfo?.feeAssetId ??
          (transactionListItem.withdrawalInfo?.withdrawalAssetId ?? 'EUR'),
    );

    return SPaddingH24(
      child: Column(
        children: [
          _BuyDetailsHeader(
            transactionListItem: transactionListItem,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              intl.global_send_receiver_details,
              style: sTextH5Style,
            ),
          ),
          const SizedBox(height: 18),
          if (transactionListItem.paymeInfo?.accountNumber != null &&
              transactionListItem.paymeInfo!.accountNumber!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_account_number,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.accountNumber ?? '',
                  ),
                  const SpaceW10(),
                  HistoryCopyIcon(transactionListItem.paymeInfo?.accountNumber ?? ''),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.recipientName != null &&
              transactionListItem.paymeInfo!.recipientName!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_beneficiary_name,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.recipientName ?? '',
                  ),
                  const SpaceW10(),
                  HistoryCopyIcon(transactionListItem.paymeInfo?.recipientName ?? ''),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.bankName != null &&
              transactionListItem.paymeInfo!.bankName!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_bank_name,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.bankName ?? '',
                  ),
                  const SpaceW10(),
                  HistoryCopyIcon(transactionListItem.paymeInfo?.bankName ?? ''),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.ifscCode != null &&
              transactionListItem.paymeInfo!.ifscCode!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_ifsc_code,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.ifscCode ?? '',
                  ),
                  const SpaceW10(),
                  HistoryCopyIcon(transactionListItem.paymeInfo?.ifscCode ?? ''),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.cardNumber != null &&
              transactionListItem.paymeInfo!.cardNumber!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_card_number,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: getCardTypeMask(
                      transactionListItem.paymeInfo?.cardNumber ?? '',
                    ),
                  ),
                  const SpaceW10(),
                  HistoryCopyIcon(transactionListItem.paymeInfo?.cardNumber ?? ''),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.iban != null && transactionListItem.paymeInfo!.iban!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_iban,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.iban ?? '',
                  ),
                  const SpaceW10(),
                  HistoryCopyIcon(transactionListItem.paymeInfo?.iban ?? ''),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.phoneNumber != null &&
              transactionListItem.paymeInfo!.phoneNumber!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_phone_number,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.phoneNumber ?? '',
                  ),
                  const SpaceW10(),
                  HistoryCopyIcon(transactionListItem.paymeInfo?.phoneNumber ?? ''),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.panNumber != null &&
              transactionListItem.paymeInfo!.panNumber!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_pan_number,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.panNumber ?? '',
                  ),
                  const SpaceW10(),
                  HistoryCopyIcon(transactionListItem.paymeInfo?.panNumber ?? ''),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.upiAddress != null &&
              transactionListItem.paymeInfo!.upiAddress!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_upi_address,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.upiAddress ?? '',
                  ),
                  const SpaceW10(),
                  HistoryCopyIcon(transactionListItem.paymeInfo?.upiAddress ?? ''),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.bankAccount != null &&
              transactionListItem.paymeInfo!.bankAccount!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_bank_account,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.bankAccount ?? '',
                  ),
                  const SpaceW10(),
                  HistoryCopyIcon(transactionListItem.paymeInfo?.bankAccount ?? ''),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              intl.global_send_payment_details,
              style: sTextH5Style,
            ),
          ),
          const SizedBox(height: 18),
          TransactionDetailsItem(
            text: intl.send_globally_date,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          if (transactionListItem.paymeInfo?.methodName != null) ...[
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.global_send_payment_method_title,
              value: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                child: TransactionDetailsValueText(
                  textAlign: TextAlign.end,
                  text: transactionListItem.paymeInfo?.methodName ?? '',
                ),
              ),
            ),
          ],
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.send_globally_con_rate,
            value: TransactionDetailsValueText(
              text:
                  '''1 ${transactionListItem.withdrawalInfo?.feeAssetId ?? transactionListItem.withdrawalInfo?.withdrawalAssetId} = ${transactionListItem.withdrawalInfo!.receiveRate} ${transactionListItem.withdrawalInfo!.receiveAsset}''',
            ),
          ),
          if (transactionListItem.status != Status.declined) ...[
            const SpaceH18(),
            ProcessingFeeRowWidget(
              fee: volumeFormat(
                decimal: transactionListItem.withdrawalInfo!.feeAmount,
                accuracy: currency.accuracy,
                symbol: currency.symbol,
              ),
            ),
          ],
          const SpaceH45(),
        ],
      ),
    );
  }
}

class _BuyDetailsHeader extends StatelessWidget {
  const _BuyDetailsHeader({
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final paymentAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.assetId),
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
        WhatToWhatConvertWidget(
          removeDefaultPaddings: true,
          isLoading: false,
          fromAssetIconUrl: paymentAsset.iconUrl,
          fromAssetDescription: paymentAsset.description,
          fromAssetValue: volumeFormat(
            symbol: paymentAsset.symbol,
            accuracy: paymentAsset.accuracy,
            decimal: transactionListItem.balanceChange.abs(),
          ),
          toAssetIconUrl: buyAsset.iconUrl,
          toAssetDescription: buyAsset.description,
          toAssetValue: volumeFormat(
            symbol: buyAsset.symbol,
            accuracy: buyAsset.accuracy,
            decimal: transactionListItem.withdrawalInfo?.receiveAmount ?? Decimal.zero,
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
