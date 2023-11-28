import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
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
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final currenciesFull = sSignalRModules.currenciesWithHiddenList;
    final currentCurrency = currencyFrom(
      currenciesFull,
      transactionListItem.assetId,
    );

    final buyCurrency = currencyFrom(
      currenciesFull,
      transactionListItem.cryptoBuyInfo!.buyAssetId,
    );

    final paymentCurrency = currencyFrom(
      currenciesFull,
      transactionListItem.cryptoBuyInfo!.paymentAssetId ?? '',
    );

    final depositCurrency = currencyFrom(
      currenciesFull,
      transactionListItem.cryptoBuyInfo!.depositFeeAsset ?? '',
    );

    String rateFor() {
      final accuracy = priceAccuracy(
        buyCurrency.symbol,
        baseCurrency.symbol,
      );

      final base = volumeFormat(
        decimal: transactionListItem.cryptoBuyInfo!.baseRate,
        accuracy: buyCurrency.accuracy,
        symbol: buyCurrency.symbol,
      );

      final quote = volumeFormat(
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
          if (transactionListItem.status != Status.declined) ...[
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
            TransactionDetailsItem(
              text: intl.withText,
              value: TransactionDetailsValueText(
                text: volumeFormat(
                  decimal: transactionListItem.cryptoBuyInfo!.paymentAmount,
                  accuracy: paymentCurrency.accuracy,
                  symbol: transactionListItem.cryptoBuyInfo!.paymentAssetId ?? '',
                ),
              ),
            ),
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.previewConvert_exchangeRate,
              value: TransactionDetailsValueText(
                text: rateFor(),
              ),
            ),
          ],
          if (transactionListItem.cryptoBuyInfo?.paymentMethod != null) ...[
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.history_payment_method,
              value: TransactionDetailsValueText(
                text: transactionListItem.cryptoBuyInfo?.paymentMethodName ??
                    getLocalOperationName(
                      transactionListItem.cryptoBuyInfo?.paymentMethod ?? PaymentMethodType.unsupported,
                    ),
              ),
            ),
          ],
          if (transactionListItem.status != Status.declined) ...[
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.history_payment_fee,
              value: TransactionDetailsValueText(
                text: volumeFormat(
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
                  decimal: transactionListItem.cryptoBuyInfo!.tradeFeeAmount,
                  accuracy: currentCurrency.accuracy,
                  symbol: currentCurrency.symbol,
                ),
              ),
            ),
          ],
          const SpaceH18(),
          TransactionDetailsStatus(status: transactionListItem.status),
          const SpaceH40(),
        ],
      ),
    );
  }
}
