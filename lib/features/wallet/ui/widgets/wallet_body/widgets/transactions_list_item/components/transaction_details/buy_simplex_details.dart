import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../../../utils/helpers/currency_from.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class BuySimplexDetails extends StatelessObserverWidget {
  const BuySimplexDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;
    final paymentCurrency = currencyFrom(
      currencies,
      transactionListItem.buyInfo!.sellAssetId,
    );

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
                decimal: transactionListItem.buyInfo!.sellAmount,
                symbol: transactionListItem.buyInfo!.sellAssetId,
                prefix: paymentCurrency.prefixSymbol,
                accuracy: paymentCurrency.accuracy,
              ),
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.buySimplexDetails_payFrom,
            value: TransactionDetailsValueText(
              text: intl.curencyBuy_actionItemName,
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.fee,
            value: TransactionDetailsValueText(
              text: _feeValue(transactionListItem),
            ),
          ),
          const SpaceH18(),
          TransactionDetailsStatus(status: transactionListItem.status),
          const SpaceH40(),
        ],
      ),
    );
  }

  String _feeValue(OperationHistoryItem transactionListItem) {
    return transactionListItem.buyInfo != null
        ? transactionListItem.buyInfo!.feeAmount > Decimal.zero
            ? '${transactionListItem.buyInfo!.feeAmount}'
                ' ${transactionListItem.buyInfo!.feeAssetId}'
            : '0 ${transactionListItem.buyInfo!.feeAmount}'
        : '0';
  }
}
