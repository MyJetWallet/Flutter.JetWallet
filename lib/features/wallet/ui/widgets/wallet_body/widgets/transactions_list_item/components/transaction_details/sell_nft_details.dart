import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class SellNftDetails extends StatelessObserverWidget {
  const SellNftDetails({
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
      transactionListItem.swapInfo!.buyAssetId,
    );

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
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.date,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
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
          TransactionDetailsItem(
            text: intl.buySellDetails_yourReceived,
            value: TransactionDetailsValueText(
              text:
                  '${transactionListItem.swapInfo!.buyAmount - transactionListItem.swapInfo!.feeAmount}'
                  ' ${buyCurrency.symbol}',
            ),
          ),
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
