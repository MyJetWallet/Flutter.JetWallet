import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class DepositDetails extends StatelessObserverWidget {
  const DepositDetails({
    Key? key,
    required this.transactionListItem,
    required this.onCopyAction,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: Column(
        children: [
          if (transactionListItem.depositInfo!.txId != null) ...[
            TransactionDetailsItem(
              text: 'Txid',
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: shortTxhashFrom(
                      transactionListItem.depositInfo!.txId ?? '',
                    ),
                  ),
                  const SpaceW10(),
                  SIconButton(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: transactionListItem.depositInfo!.txId ?? '',
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
          ],
          if (transactionListItem.depositInfo?.network != null) ...[
            const SpaceH16(),
            TransactionDetailsItem(
              text: intl.cryptoDeposit_network,
              value: TransactionDetailsValueText(
                text: transactionListItem.depositInfo?.network ?? '',
              ),
            ),
          ],
          const SpaceH16(),
          TransactionDetailsItem(
            text: intl.date,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          const SpaceH16(),
          TransactionDetailsStatus(
            status: transactionListItem.status,
          ),
          const SpaceH40(),
        ],
      ),
    );
  }
}
