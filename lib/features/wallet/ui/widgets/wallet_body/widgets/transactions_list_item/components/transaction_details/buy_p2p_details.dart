import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/price_accuracy.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../../../utils/helpers/check_local_operation.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class BuyP2PDetails extends StatelessObserverWidget {
  const BuyP2PDetails({
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
    final currenciesFull = sSignalRModules.currenciesWithHiddenList;
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

    final depositCurrency = currencyFrom(
      currenciesFull,
      transactionListItem.cryptoBuyInfo!.depositFeeAsset,
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
        prefix: paymentCurrency.prefixSymbol,
        decimal: transactionListItem.cryptoBuyInfo!.quoteRate,
        accuracy: accuracy,
        symbol: paymentCurrency.symbol,
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
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.previewConvert_exchangeRate,
            value: TransactionDetailsValueText(
              text: _rateFor(),
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.history_payment_method,
            value: TransactionDetailsValueText(
              text: getLocalOperationName(
                transactionListItem.cryptoBuyInfo?.paymentMethod ??
                PaymentMethodType.unsupported,
              ),
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.history_payment_fee,
            value: TransactionDetailsValueText(
              text: volumeFormat(
                prefix: depositCurrency.prefixSymbol,
                decimal: transactionListItem.cryptoBuyInfo!.depositFeeAmount,
                accuracy: depositCurrency.accuracy,
                symbol: depositCurrency.symbol,
              ),
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.history_our_fee,
            value: TransactionDetailsValueText(
              text: volumeFormat(
                prefix: currentCurrency.prefixSymbol,
                decimal: transactionListItem.cryptoBuyInfo!.tradeFeeAmount,
                accuracy: currentCurrency.accuracy,
                symbol: currentCurrency.symbol,
              ),
            ),
          ),
          const SpaceH18(),
          TransactionDetailsStatus(status: transactionListItem.status),
          const SpaceH40(),
        ],
      ),
    );
  }
}
