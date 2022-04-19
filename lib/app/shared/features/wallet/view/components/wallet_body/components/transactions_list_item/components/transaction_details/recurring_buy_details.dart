import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../../helpers/formatting/base/volume_format.dart';
import '../../../../../../../../../helpers/price_accuracy.dart';
import '../../../../../../../../../helpers/short_address_form.dart';
import '../../../../../../../../../models/currency_model.dart';
import '../../../../../../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../../../../../../market_details/helper/currency_from.dart';
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
    final currencies = context.read(currenciesPod);

    final buyCurrency = currencyFrom(
      currencies,
      transactionListItem.recurringBuyInfo!.buyAssetId,
    );

    final sellCurrency = currencyFrom(
      currencies,
      transactionListItem.recurringBuyInfo!.sellAssetId,
    );

    String _rateFor(
        CurrencyModel currency1,
        CurrencyModel currency2,
        ) {

      final accuracy = priceAccuracy(
        context.read,
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

    return SPaddingH24(
      child: Column(
        children: [
          TransactionDetailsItem(
            text: 'Transaction ID',
            value: Row(
              children: [
                TransactionDetailsValueText(
                  text: shortAddressForm(transactionListItem.operationId),
                ),
                const SpaceW10(),
                SIconButton(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: transactionListItem.operationId,
                      ),
                    );

                    onCopyAction('Transaction ID');
                  },
                  defaultIcon: const SCopyIcon(),
                  pressedIcon: const SCopyPressedIcon(),
                ),
              ],
            ),
          ),
          const SpaceH14(),
            TransactionDetailsItem(
              text: 'With',
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
              text: 'Fee',
              value: TransactionDetailsValueText(
                text: _feeValue(transactionListItem),
              ),
            ),
            const SpaceH14(),
            TransactionDetailsItem(
              text: 'Rate',
              value: TransactionDetailsValueText(
                text: _rateFor(buyCurrency, sellCurrency),
              ),
            ),
        ],
      ),
    );
  }

  String _feeValue(OperationHistoryItem transactionListItem) {
    if (transactionListItem.recurringBuyInfo != null) {
      if (transactionListItem.recurringBuyInfo!.feeAmount > Decimal.zero) {
        return '${transactionListItem.recurringBuyInfo!.feeAmount}'
            ' ${transactionListItem.recurringBuyInfo!.feeAsset}';
      } else {
        return '0 ${transactionListItem.recurringBuyInfo!.feeAmount}';
      }
    } else {
      return '0';
    }
  }
}
