import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../../helpers/formatting/formatting.dart';
import '../../../../../../../../../helpers/short_address_form.dart';
import '../../../../../../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../../../../../../market_details/helper/currency_from.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class BuySimplexDetails extends StatelessWidget {
  const BuySimplexDetails({
    Key? key,
    required this.transactionListItem,
    required this.onCopyAction,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final currencies = context.read(currenciesPod);

    final simplexCurrency = currencyFrom(
      currencies,
      transactionListItem.buyInfo!.buyAssetId,
    );

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
                prefix: simplexCurrency.prefixSymbol,
                decimal: transactionListItem.buyInfo!.sellAmount,
                accuracy: simplexCurrency.accuracy,
                symbol: simplexCurrency.symbol,
              ),
            ),
          ),
          const SpaceH14(),
          const TransactionDetailsItem(
            text: 'Pay from',
            value: TransactionDetailsValueText(
              text: 'Bank Card - Simplex',
            ),
          ),
          const SpaceH14(),
          TransactionDetailsItem(
            text: 'Fee',
            value: TransactionDetailsValueText(
              text: _feeValue(transactionListItem),
            ),
          ),
        ],
      ),
    );
  }

  String _feeValue(OperationHistoryItem transactionListItem) {
    if (transactionListItem.buyInfo != null) {
      if (transactionListItem.buyInfo!.feeAmount > Decimal.zero) {
        return '${transactionListItem.buyInfo!.feeAmount}'
            ' ${transactionListItem.buyInfo!.feeAssetId}';
      } else {
        return '0 ${transactionListItem.buyInfo!.feeAmount}';
      }
    } else {
      return '0';
    }
  }
}
