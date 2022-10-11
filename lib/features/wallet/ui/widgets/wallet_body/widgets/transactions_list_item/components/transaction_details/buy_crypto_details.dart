import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/price_accuracy.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class BuyCryptoDetails extends StatelessObserverWidget {
  const BuyCryptoDetails({
    Key? key,
    required this.transactionListItem,
    required this.onCopyAction,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final currencies = sSignalRModules.currenciesList;
    final currentCurrency = currencyFrom(
      currencies,
      transactionListItem.assetId,
    );

    final buyCurrency = currencyFrom(
      currencies,
      transactionListItem.cryptoBuyInfo!.buyAssetId,
    );

    final paymentCurrency = currencyFrom(
      currencies,
      transactionListItem.cryptoBuyInfo!.paymentAssetId,
    );

    String _rateFor() {
      final accuracy = priceAccuracy(
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
              text: volumeFormat(
                decimal: transactionListItem.cryptoBuyInfo!.paymentAmount,
                accuracy: paymentCurrency.accuracy,
                symbol: transactionListItem.cryptoBuyInfo!.paymentAssetId,
                prefix: paymentCurrency.prefixSymbol,
              ),
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
