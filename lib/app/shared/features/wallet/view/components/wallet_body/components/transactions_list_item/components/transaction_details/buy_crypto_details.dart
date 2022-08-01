import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/operation_history/model/operation_history_response_model.dart';

import '../../../../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../../../../helpers/formatting/formatting.dart';
import '../../../../../../../../../helpers/price_accuracy.dart';
import '../../../../../../../../../helpers/short_address_form.dart';
import '../../../../../../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../../../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../../../../../../market_details/helper/currency_from.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class BuyCryptoDetails extends HookWidget {
  const BuyCryptoDetails({
    Key? key,
    required this.transactionListItem,
    required this.onCopyAction,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final baseCurrency = useProvider(baseCurrencyPod);
    final currencies = useProvider(currenciesPod);
    final currentCurrency = currencyFrom(
      currencies,
      transactionListItem.assetId,
    );

    final buyCurrency = currencyFrom(
      currencies,
      transactionListItem.cryptoBuyInfo!.buyAssetId,
    );

    String _rateFor() {
      final accuracy = priceAccuracy(
        context.read,
        buyCurrency.symbol,
        baseCurrency.symbol,
      );

      final base = volumeFormat(
        prefix: buyCurrency.prefixSymbol,
        decimal: transactionListItem.cryptoBuyInfo!.baseRate,
        accuracy: buyCurrency.accuracy,
        symbol: buyCurrency.symbol,
      );

      final quote = volumeFormat(
        prefix: baseCurrency.prefix,
        decimal: transactionListItem.cryptoBuyInfo!.quoteRate,
        accuracy: accuracy,
        symbol: baseCurrency.symbol,
      );

      return '$base = $quote';
    }

    return SPaddingH24(
      child: Column(
        children: [
          TransactionDetailsItem(
            text: '${intl.transaction} ID',
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

                    onCopyAction('${intl.transaction} ID');
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
              text: '\$${transactionListItem.cryptoBuyInfo!.paymentAmount}',
            ),
          ),
          if (transactionListItem.cryptoBuyInfo!.cardLast4.isNotEmpty) ...[
            const SpaceH14(),
            TransactionDetailsItem(
              text: intl.previewBuyWithCircle_payFrom,
              value: TransactionDetailsValueText(
                text: '${transactionListItem.cryptoBuyInfo!.cardType ?? ''} '
                    '•••• ${transactionListItem.cryptoBuyInfo!.cardLast4}',
              ),
            ),
          ],
          const SpaceH14(),
          TransactionDetailsItem(
            text: intl.previewBuyWithCircle_creditCardFee,
            value: TransactionDetailsValueText(
              text: volumeFormat(
                prefix: baseCurrency.prefix,
                decimal: transactionListItem.cryptoBuyInfo!.depositFeeAmount,
                accuracy: baseCurrency.accuracy,
                symbol: baseCurrency.symbol,
              ),
            ),
          ),
          const SpaceH14(),
          TransactionDetailsItem(
            text: intl.previewBuyWithCircle_transactionFee,
            value: TransactionDetailsValueText(
              text: volumeFormat(
                prefix: currentCurrency.prefixSymbol,
                decimal: transactionListItem.cryptoBuyInfo!.tradeFeeAmount,
                accuracy: currentCurrency.accuracy,
                symbol: currentCurrency.symbol,
              ),
            ),
          ),
          const SpaceH14(),
          TransactionDetailsItem(
            text: intl.previewBuyWithCircle_payFrom,
            value: TransactionDetailsValueText(
              text: _rateFor(),
            ),
          ),
          const SpaceH16(),
          TransactionDetailsStatus(status: transactionListItem.status),
          const SpaceH40(),
        ],
      ),
    );
  }
}
