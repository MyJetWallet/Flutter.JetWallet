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
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class BuyDetails extends StatelessObserverWidget {
  const BuyDetails({
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
          (element) => element.symbol == (transactionListItem.cryptoBuyInfo?.paymentAssetId ?? 'EUR'),
        )
        .first;

    final buyAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.cryptoBuyInfo?.buyAssetId ?? 'EUR'),
        )
        .first;

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
            text: intl.buy_confirmation_price,
            value: TransactionDetailsValueText(
              text: rateFor(buyAsset, paymentAsset),
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
                transactionListItem.cryptoBuyInfo?.paymentAssetId ??
                    transactionListItem.cryptoBuyInfo?.paymentAssetId ??
                    '',
              );

              return TransactionDetailsItem(
                text: intl.iban_send_history_payment_fee,
                value: TransactionDetailsValueText(
                  text: volumeFormat(
                    decimal: transactionListItem.cryptoBuyInfo?.paymentAmount ?? Decimal.zero,
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
                transactionListItem.cryptoBuyInfo?.tradeFeeAsset ??
                    transactionListItem.cryptoBuyInfo?.paymentAssetId ??
                    '',
              );

              return TransactionDetailsItem(
                text: intl.iban_send_history_processin_fee,
                value: TransactionDetailsValueText(
                  text: volumeFormat(
                    decimal: transactionListItem.cryptoBuyInfo?.tradeFeeAmount ?? Decimal.zero,
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

  String rateFor(
    CurrencyModel currency1,
    CurrencyModel currency2,
  ) {
    final accuracy = priceAccuracy(
      currency1.symbol,
      currency2.symbol,
    );

    final base = volumeFormat(
      decimal: transactionListItem.cryptoBuyInfo!.baseRate,
      accuracy: currency1.accuracy,
      symbol: currency1.symbol,
    );

    final quote = volumeFormat(
      decimal: transactionListItem.cryptoBuyInfo!.quoteRate,
      accuracy: accuracy,
      symbol: currency2.symbol,
    );

    return '$base = $quote';
  }
}

class BuyDetailsHeader extends StatelessWidget {
  const BuyDetailsHeader({
    super.key,
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final paymentAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.cryptoBuyInfo?.paymentAssetId ?? 'EUR'),
        )
        .first;

    final buyAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.cryptoBuyInfo?.buyAssetId ?? 'EUR'),
        )
        .first;

    return SPaddingH24(
      child: Column(
        children: [
          WhatToWhatConvertWidget(
            removeDefaultPaddings: true,
            isLoading: false,
            fromAssetIconUrl: paymentAsset.iconUrl,
            fromAssetDescription: transactionListItem.withdrawalInfo?.contactName ?? '',
            fromAssetValue: volumeFormat(
              symbol: paymentAsset.symbol,
              accuracy: paymentAsset.accuracy,
              decimal: transactionListItem.cryptoBuyInfo?.paymentAmount ?? Decimal.zero,
            ),
            fromAssetCustomIcon: const BlueBankIcon(),
            toAssetIconUrl: buyAsset.iconUrl,
            toAssetDescription: buyAsset.description,
            toAssetValue: volumeFormat(
              symbol: buyAsset.symbol,
              accuracy: buyAsset.accuracy,
              decimal: transactionListItem.cryptoBuyInfo?.buyAmount ?? Decimal.zero,
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
