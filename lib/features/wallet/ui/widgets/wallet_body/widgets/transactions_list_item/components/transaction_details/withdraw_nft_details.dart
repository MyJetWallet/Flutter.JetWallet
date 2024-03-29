import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class WithdrawNftDetails extends StatelessObserverWidget {
  const WithdrawNftDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: Column(
        children: [
          TransactionDetailsItem(
            text: '${intl.transaction} ${intl.withdrawDetails_fee}',
            value: transactionListItem.withdrawalInfo!.isInternal
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TransactionDetailsValueText(
                        text: intl.noFee,
                      ),
                      Text(
                        intl.withdrawDetails_internalTransfer,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Builder(
                    builder: (context) {
                      final currency = currencyFrom(
                        sSignalRModules.currenciesWithHiddenList,
                        transactionListItem.withdrawalInfo!.feeAssetId ??
                            transactionListItem.withdrawalInfo!.withdrawalAssetId!,
                      );

                      return TransactionDetailsValueText(
                        text: volumeFormat(
                          decimal: transactionListItem.withdrawalInfo!.feeAmount,
                          accuracy: currency.accuracy,
                          symbol: currency.symbol,
                        ),
                      );
                    },
                  ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: 'Txid',
            value: Row(
              children: [
                TransactionDetailsValueText(
                  text: shortAddressFormTwo(transactionListItem.operationId),
                ),
                const SpaceW10(),
                HistoryCopyIcon(transactionListItem.operationId),
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
          if (transactionListItem.withdrawalInfo!.toAddress != null) ...[
            TransactionDetailsItem(
              text: intl.withdrawOptions_sendTo,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.withdrawalInfo!.toAddress != null
                        ? shortTxhashFrom(
                            transactionListItem.withdrawalInfo!.toAddress!,
                          )
                        : '',
                  ),
                  const SpaceW10(),
                  HistoryCopyIcon(transactionListItem.withdrawalInfo!.toAddress ?? ''),
                ],
              ),
            ),
            const SpaceH14(),
          ],
          TransactionDetailsStatus(
            status: transactionListItem.status,
          ),
          const SpaceH40(),
        ],
      ),
    );
  }
}
