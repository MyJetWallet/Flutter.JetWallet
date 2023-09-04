import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/transaction_details_name_text.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class DepositDetails extends StatelessObserverWidget {
  const DepositDetails({
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
          if (transactionListItem.depositInfo!.txId != null) ...[
            const SpaceH18(),
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
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.cryptoDeposit_network,
              value: TransactionDetailsValueText(
                text: transactionListItem.depositInfo?.network ?? '',
              ),
            ),
          ],
          if (transactionListItem.depositInfo?.address != null) ...[
            const SpaceH18(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TransactionDetailsNameText(
                  text: intl.from,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                Flexible(
                  child: TransactionDetailsValueText(
                    text: transactionListItem.depositInfo!.address ?? '',
                  ),
                ),
                const SpaceW8(),
                SIconButton(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: transactionListItem.depositInfo!.address ?? '',
                      ),
                    );

                    onCopyAction(intl.withdrawDetails_withdrawalTo);
                  },
                  defaultIcon: const SCopyIcon(),
                  pressedIcon: const SCopyPressedIcon(),
                ),
              ],
            ),
          ],
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
