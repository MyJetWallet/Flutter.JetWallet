import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../wallet/helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class ReceiveDetails extends StatelessObserverWidget {
  const ReceiveDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final senderName = transactionListItem.receiveByPhoneInfo!.senderName ?? '';
    final fromPhoneNumber = transactionListItem.receiveByPhoneInfo?.fromPhoneNumber ?? '';

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
                HistoryCopyIcon(transactionListItem.operationId),
              ],
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: '${intl.transaction} ${intl.from}',
            fromStart: fromPhoneNumber.isNotEmpty && senderName.isNotEmpty,
            value: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (fromPhoneNumber.isNotEmpty)
                  Text(
                    fromPhoneNumber,
                    style: sSubtitle3Style.copyWith(
                      color: colors.black,
                      height: 1.3125,
                    ),
                    maxLines: 5,
                  ),
                if (senderName.isNotEmpty) ...[
                  Text(
                    senderName,
                    style: sBodyText2Style.copyWith(
                      color: colors.grey1,
                    ),
                  ),
                ],
                if (fromPhoneNumber.isNotEmpty && senderName.isNotEmpty) const SpaceH12(),
              ],
            ),
          ),
          const SpaceH14(),
          TransactionDetailsStatus(
            status: transactionListItem.status,
          ),
          const SpaceH42(),
        ],
      ),
    );
  }
}
