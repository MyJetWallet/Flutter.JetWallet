import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class IbanSendDetails extends StatelessObserverWidget {
  const IbanSendDetails({
    Key? key,
    required this.transactionListItem,
    required this.onCopyAction,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      'EUR',
    );

    return SPaddingH24(
      child: Column(
        children: [
          TransactionDetailsItem(
            text: intl.send_globally_date,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          const SpaceH18(),
          Builder(
            builder: (context) {
              final currency = currencyFrom(
                sSignalRModules.currenciesList,
                transactionListItem.withdrawalInfo!.feeAssetId ??
                    transactionListItem.withdrawalInfo!.withdrawalAssetId,
              );

              return TransactionDetailsItem(
                text: intl.iban_send_history_transaction_fee,
                value: TransactionDetailsValueText(
                  text: volumeFormat(
                    prefix: currency.prefixSymbol,
                    decimal: transactionListItem.withdrawalInfo!.feeAmount,
                    accuracy: currency.accuracy,
                    symbol: currency.symbol,
                  ),
                ),
              );
            },
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.iban_send_history_transaction_id,
            value: Row(
              children: [
                TransactionDetailsValueText(
                  text: shortTxhashFrom(
                    transactionListItem.withdrawalInfo?.toAddress ?? '',
                  ),
                ),
                const SpaceW10(),
                SIconButton(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text:
                            transactionListItem.withdrawalInfo?.toAddress ?? '',
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
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.iban_send_history_send_to,
            value: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.46,
                      ),
                      child: TransactionDetailsValueText(
                        textAlign: TextAlign.end,
                        text: transactionListItem.withdrawalInfo?.contactName ??
                            '',
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.46,
                      ),
                      child: TransactionDetailsValueText(
                        textAlign: TextAlign.end,
                        text:
                            transactionListItem.withdrawalInfo?.toAddress ?? '',
                        color: sKit.colors.grey1,
                      ),
                    ),
                  ],
                ),
                const SpaceW10(),
                SIconButton(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text:
                            '${transactionListItem.withdrawalInfo?.contactName ?? ''}\n${transactionListItem.withdrawalInfo?.toAddress ?? ''}',
                      ),
                    );

                    onCopyAction(intl.iban_send_history_send_to);
                  },
                  defaultIcon: const SCopyIcon(),
                  pressedIcon: const SCopyPressedIcon(),
                ),
              ],
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
