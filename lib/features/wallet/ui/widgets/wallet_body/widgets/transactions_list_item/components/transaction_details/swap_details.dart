import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/price_accuracy.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/fee_rows/processing_fee_row_widget.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class SwapDetails extends StatelessObserverWidget {
  const SwapDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final paymentAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.swapInfo?.sellAssetId ?? 'EUR'),
        )
        .first;

    final buyAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.swapInfo?.buyAssetId ?? 'EUR'),
        )
        .first;

    return SPaddingH24(
      child: Column(
        children: [
          _SwapDetailsHeader(
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
            text: intl.buy_confirmation_price,
            value: TransactionDetailsValueText(
              text: rateFor(buyAsset, paymentAsset),
            ),
          ),
          const SpaceH18(),
          Builder(
            builder: (context) {
              final currency = currencyFrom(
                sSignalRModules.currenciesList,
                transactionListItem.swapInfo?.feeAsset ?? '',
              );

              return ProcessingFeeRowWidget(
                fee: volumeFormat(
                  decimal: transactionListItem.swapInfo?.feeAmount ?? Decimal.zero,
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

  String rateFor(
    CurrencyModel currency1,
    CurrencyModel currency2,
  ) {
    final accuracy = priceAccuracy(
      currency1.symbol,
      currency2.symbol,
    );

    final base = volumeFormat(
      decimal: transactionListItem.swapInfo!.baseRate,
      accuracy: currency1.accuracy,
      symbol: currency1.symbol,
    );

    final quote = volumeFormat(
      decimal: transactionListItem.swapInfo!.quoteRate,
      accuracy: accuracy,
      symbol: currency2.symbol,
    );

    return '$base = $quote';
  }
}

class _SwapDetailsHeader extends StatelessWidget {
  const _SwapDetailsHeader({
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final paymentAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.swapInfo?.sellAssetId ?? 'EUR'),
        )
        .first;

    final buyAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.swapInfo?.buyAssetId ?? 'EUR'),
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
            decimal: transactionListItem.swapInfo?.sellAmount ?? Decimal.zero,
          ),
          toAssetIconUrl: buyAsset.iconUrl,
          toAssetDescription: buyAsset.description,
          toAssetValue: volumeFormat(
            symbol: buyAsset.symbol,
            accuracy: buyAsset.accuracy,
            decimal: transactionListItem.swapInfo?.buyAmount ?? Decimal.zero,
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
