import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class BuySellDetails extends StatelessObserverWidget {
  const BuySellDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesWithHiddenList;

    final buyCurrency = currencyFrom(
      currencies,
      transactionListItem.swapInfo!.buyAssetId,
    );

    final sellCurrency = currencyFrom(
      currencies,
      transactionListItem.swapInfo!.sellAssetId ?? '',
    );

    String rateFor(
      CurrencyModel currency1,
      CurrencyModel currency2,
    ) {
      final base = volumeFormat(
        decimal: transactionListItem.swapInfo!.baseRate,
        symbol: currency1.symbol,
      );

      final quote = volumeFormat(
        decimal: transactionListItem.swapInfo!.quoteRate,
        symbol: currency2.symbol,
      );

      return '$base = $quote';
    }

    return SPaddingH24(
      child: Column(
        children: [
          TransactionDetailsItem(
            text: intl.date,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: 'Txid',
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
          if (transactionListItem.operationType == OperationType.swapBuy) ...[
            TransactionDetailsItem(
              text: intl.withText,
              value: TransactionDetailsValueText(
                text: volumeFormat(
                  decimal: transactionListItem.swapInfo!.sellAmount,
                  accuracy: sellCurrency.accuracy,
                  symbol: sellCurrency.symbol,
                ),
              ),
            ),
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.buySellDetails_rate,
              value: TransactionDetailsValueText(
                text: rateFor(buyCurrency, sellCurrency),
              ),
            ),
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.fee,
              value: TransactionDetailsValueText(
                text: _feeValue(transactionListItem),
              ),
            ),
          ],
          if (transactionListItem.operationType == OperationType.swapSell) ...[
            TransactionDetailsItem(
              text: intl.buySellDetails_forText,
              value: TransactionDetailsValueText(
                text: volumeFormat(
                  decimal: transactionListItem.swapInfo!.buyAmount,
                  accuracy: buyCurrency.accuracy,
                  symbol: buyCurrency.symbol,
                ),
              ),
            ),
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.buySellDetails_rate,
              value: TransactionDetailsValueText(
                text: rateFor(sellCurrency, buyCurrency),
              ),
            ),
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.fee,
              value: TransactionDetailsValueText(
                text: _feeValue(transactionListItem),
              ),
            ),
          ],
          const SpaceH40(),
        ],
      ),
    );
  }

  String _feeValue(OperationHistoryItem transactionListItem) {
    return transactionListItem.swapInfo != null
        ? transactionListItem.swapInfo!.feeAmount > Decimal.zero
            ? '${transactionListItem.swapInfo!.feeAmount}'
                ' ${transactionListItem.swapInfo!.feeAsset}'
            : '0 ${transactionListItem.swapInfo!.feeAsset}'
        : '0';
  }
}
