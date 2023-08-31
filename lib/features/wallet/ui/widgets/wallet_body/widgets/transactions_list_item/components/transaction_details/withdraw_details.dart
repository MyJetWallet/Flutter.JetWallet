import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/transaction_details_name_text.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class WithdrawDetails extends StatelessObserverWidget {
  const WithdrawDetails({
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
            text: intl.date,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          const SpaceH18(),
          if (transactionListItem.withdrawalInfo!.txId != null &&
              !transactionListItem.withdrawalInfo!.isInternal) ...[
            TransactionDetailsItem(
              text: 'Txhash',
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: shortTxhashFrom(
                      transactionListItem.withdrawalInfo!.txId ?? '',
                    ),
                  ),
                  const SpaceW10(),
                  SIconButton(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: transactionListItem.withdrawalInfo!.txId ?? '',
                        ),
                      );

                      onCopyAction('Txhash');
                    },
                    defaultIcon: const SCopyIcon(),
                    pressedIcon: const SCopyPressedIcon(),
                  ),
                ],
              ),
            ),
          ],
          const SpaceH18(),
          if (transactionListItem.withdrawalInfo!.toAddress != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TransactionDetailsNameText(
                  text: intl.to1,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                //const SpaceW12(),
                Flexible(
                  child: TransactionDetailsValueText(
                    text: transactionListItem.withdrawalInfo!.toAddress ?? '',
                  ),
                ),
                const SpaceW8(),
                SIconButton(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text:
                            transactionListItem.withdrawalInfo!.toAddress ?? '',
                      ),
                    );

                    onCopyAction(intl.withdrawDetails_withdrawalTo);
                  },
                  defaultIcon: const SCopyIcon(),
                  pressedIcon: const SCopyPressedIcon(),
                ),
              ],
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.withdrawalInfo!.network != null) ...[
            TransactionDetailsItem(
              text: intl.cryptoDeposit_network,
              value: TransactionDetailsValueText(
                text: transactionListItem.withdrawalInfo!.network ?? '',
              ),
            ),
            const SpaceH18(),
          ],
          TransactionDetailsItem(
            text: intl.fee,
            fromStart: transactionListItem.withdrawalInfo!.isInternal,
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
                const SpaceH12(),
              ],
            )
                : Builder(
              builder: (context) {
                final currency = currencyFrom(
                  sSignalRModules.currenciesList,
                  transactionListItem.withdrawalInfo!.feeAssetId ??
                      transactionListItem
                          .withdrawalInfo!.withdrawalAssetId,
                );

                return TransactionDetailsValueText(
                  text: volumeFormat(
                    prefix: currency.prefixSymbol,
                    decimal:
                    transactionListItem.withdrawalInfo!.feeAmount,
                    accuracy: currency.accuracy,
                    symbol: currency.symbol,
                  ),
                );
              },
            ),
          ),
          const SpaceH18(),
          TransactionDetailsStatus(
            status: transactionListItem.status,
          ),
          const SpaceH40(),
        ],
      ),
    );
  }
}
