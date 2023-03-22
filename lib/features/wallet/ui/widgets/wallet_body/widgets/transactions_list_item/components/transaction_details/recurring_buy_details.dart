import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/price_accuracy.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class RecurringBuyDetails extends StatelessWidget {
  const RecurringBuyDetails({
    Key? key,
    required this.transactionListItem,
    required this.onCopyAction,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;

    final buyCurrency = currencyFrom(
      currencies,
      transactionListItem.recurringBuyInfo!.buyAssetId!,
    );

    final sellCurrency = currencyFrom(
      currencies,
      transactionListItem.recurringBuyInfo!.sellAssetId!,
    );

    String _rateFor(
      CurrencyModel currency1,
      CurrencyModel currency2,
    ) {
      final accuracy = priceAccuracy(
        currency1.symbol,
        currency2.symbol,
      );

      final base = volumeFormat(
        prefix: currency1.prefixSymbol,
        decimal: transactionListItem.recurringBuyInfo!.baseRate,
        accuracy: currency1.accuracy,
        symbol: currency1.symbol,
      );

      final quote = volumeFormat(
        prefix: currency2.prefixSymbol,
        decimal: transactionListItem.recurringBuyInfo!.quoteRate,
        accuracy: accuracy,
        symbol: currency2.symbol,
      );

      return '$base = $quote';
    }

    String _feeValue(OperationHistoryItem transactionListItem) {
      return transactionListItem.recurringBuyInfo != null
          ? transactionListItem.recurringBuyInfo!.feeAmount > Decimal.zero
              ? '${transactionListItem.recurringBuyInfo!.feeAmount}'
                  ' ${transactionListItem.recurringBuyInfo!.feeAsset}'
              : transactionListItem.recurringBuyInfo!.feeAmount == Decimal.zero
                  ? '0'
                  : '0 ${transactionListItem.recurringBuyInfo!.feeAmount}'
          : '0';
    }

    return SPaddingH24(
      child: Column(
        children: [
          TransactionDetailsItem(
            text: 'Txid',
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
          const SpaceH14(),
          TransactionDetailsItem(
            text: intl.withText,
            value: TransactionDetailsValueText(
              text: volumeFormat(
                prefix: sellCurrency.prefixSymbol,
                decimal: transactionListItem.recurringBuyInfo!.sellAmount,
                accuracy: sellCurrency.accuracy,
                symbol: sellCurrency.symbol,
              ),
            ),
          ),
          const SpaceH14(),
          TransactionDetailsItem(
            text: intl.fee,
            value: TransactionDetailsValueText(
              text: _feeValue(transactionListItem),
            ),
          ),
          const SpaceH14(),
          TransactionDetailsItem(
            text: intl.recurringBuyDetails_rate,
            value: TransactionDetailsValueText(
              text: _rateFor(buyCurrency, sellCurrency),
            ),
          ),
          const SpaceH40(),
        ],
      ),
    );
  }
}
