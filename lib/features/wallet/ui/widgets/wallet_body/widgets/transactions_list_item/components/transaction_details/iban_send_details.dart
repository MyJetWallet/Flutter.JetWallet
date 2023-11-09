import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/split_iban.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class IbanSendDetails extends StatelessObserverWidget {
  const IbanSendDetails({
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
                SIconButton(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: transactionListItem.operationId,
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
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.iban_send_history_send_to,
            fromStart: true,
            value: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.46,
                      ),
                      child: TransactionDetailsValueText(
                        textAlign: TextAlign.end,
                        text: (transactionListItem.withdrawalInfo?.contactName ?? '').trim(),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.46,
                      ),
                      child: TransactionDetailsValueText(
                        textAlign: TextAlign.end,
                        text: splitIban((transactionListItem.withdrawalInfo?.toAddress ?? '').trim()),
                        color: sKit.colors.grey1,
                      ),
                    ),
                  ],
                ),
                const SpaceW10(),
                SIconButton(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text:
                            '''${transactionListItem.withdrawalInfo?.contactName ?? ''}\n${transactionListItem.withdrawalInfo?.toAddress ?? ''}''',
                      ),
                    );

                    onCopyAction(intl.iban_send_history_send_to);
                  },
                  defaultIcon: const SCopyIcon(),
                  pressedIcon: const SCopyPressedIcon(),
                ),
              ],
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.iban_send_history_beneficairy,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          const SpaceH18(),
          Builder(
            builder: (context) {
              final currency = currencyFrom(
                sSignalRModules.currenciesList,
                transactionListItem.withdrawalInfo?.feeAssetId ??
                    transactionListItem.withdrawalInfo?.withdrawalAssetId ??
                    '',
              );

              return TransactionDetailsItem(
                text: intl.iban_send_history_payment_fee,
                value: TransactionDetailsValueText(
                  text: volumeFormat(
                    decimal: transactionListItem.withdrawalInfo?.feeAmount ?? Decimal.zero,
                    accuracy: currency.accuracy,
                    symbol: currency.symbol,
                  ),
                ),
              );
            },
          ),
          const SpaceH18(),
          Builder(
            builder: (context) {
              final currency = currencyFrom(
                sSignalRModules.currenciesList,
                transactionListItem.withdrawalInfo?.feeAssetId ??
                    transactionListItem.withdrawalInfo?.withdrawalAssetId ??
                    '',
              );

              return TransactionDetailsItem(
                text: intl.iban_send_history_processin_fee,
                value: TransactionDetailsValueText(
                  text: volumeFormat(
                    decimal: transactionListItem.withdrawalInfo?.feeAmount ?? Decimal.zero,
                    accuracy: currency.accuracy,
                    symbol: currency.symbol,
                  ),
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

class IbanSendDetailsHeader extends StatelessWidget {
  const IbanSendDetailsHeader({
    super.key,
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final asset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.withdrawalInfo?.withdrawalAssetId ?? 'EUR'),
        )
        .first;

    return SPaddingH24(
      child: Column(
        children: [
          WhatToWhatConvertWidget(
            removeDefaultPaddings: true,
            isLoading: false,
            fromAssetIconUrl: '',
            fromAssetDescription: transactionListItem.withdrawalInfo?.contactName ?? '',
            fromAssetValue: volumeFormat(
              symbol: asset.symbol,
              accuracy: asset.accuracy,
              decimal: transactionListItem.withdrawalInfo?.withdrawalAmount ?? Decimal.zero,
            ),
            fromAssetCustomIcon: const BlueBankIcon(),
            toAssetIconUrl: asset.iconUrl,
            toAssetDescription: asset.description,
            toAssetValue: volumeFormat(
              symbol: asset.symbol,
              accuracy: asset.accuracy,
              decimal: (transactionListItem.withdrawalInfo?.withdrawalAmount ?? Decimal.zero) -
                  (transactionListItem.withdrawalInfo?.feeAmount ?? Decimal.zero),
            ),
            isError: transactionListItem.status == Status.declined,
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
      ),
    );
  }
}
