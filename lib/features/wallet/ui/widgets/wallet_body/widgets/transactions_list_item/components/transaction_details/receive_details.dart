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

class ReceiveDetails extends StatelessObserverWidget {
  const ReceiveDetails({
    Key? key,
    required this.transactionListItem,
    required this.onCopyAction,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final senderName = transactionListItem.receiveByPhoneInfo!.senderName ?? '';
    final fromPhoneNumber =
        transactionListItem.receiveByPhoneInfo?.fromPhoneNumber ?? '';

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
          const SpaceH14(),
          TransactionDetailsItem(
            text: intl.date,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          const SpaceH14(),
          TransactionDetailsItem(
            text: '${intl.transaction} ${intl.from}',
            value: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (fromPhoneNumber.isNotEmpty)
                  TransactionDetailsValueText(
                    text: fromPhoneNumber,
                  ),
                if (senderName.isNotEmpty) ...[
                  Text(
                    senderName,
                    style: sBodyText2Style.copyWith(
                      color: colors.grey1,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SpaceH10(),
          TransactionDetailsStatus(
            status: transactionListItem.status,
          ),
          const SpaceH42(),
        ],
      ),
    );
  }
}
