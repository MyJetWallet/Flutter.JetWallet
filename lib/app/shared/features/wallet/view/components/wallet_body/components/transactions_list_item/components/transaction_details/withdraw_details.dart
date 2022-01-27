import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../../helpers/short_address_form.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class WithdrawDetails extends StatelessWidget {
  const WithdrawDetails({
    Key? key,
    required this.transactionListItem,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: Column(
        children: [
          TransactionDetailsItem(
            text: 'Amount',
            value: TransactionDetailsValueText(
              text: '${transactionListItem.withdrawalInfo!.withdrawalAmount}',
            ),
          ),
          const SpaceH10(),
          TransactionDetailsItem(
            text: 'Transaction fee',
            value: transactionListItem.withdrawalInfo!.isInternal
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      TransactionDetailsValueText(
                        text: 'No Fee',
                      ),
                      Text(
                        'Internal transfer',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : TransactionDetailsValueText(
                    text: '${transactionListItem.withdrawalInfo!.feeAmount} '
                        '${transactionListItem.withdrawalInfo!.feeAssetId}',
                  ),
          ),
          const SpaceH10(),
          TransactionDetailsItem(
            text: 'Transaction ID',
            value: Row(
              children: [
                TransactionDetailsValueText(
                  text: shortAddressForm(transactionListItem.operationId),
                ),
                const SpaceW10(),
                SIconButton(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: transactionListItem.operationId,
                      ),
                    );
                  },
                  defaultIcon: const SCopyIcon(),
                  pressedIcon: const SCopyPressedIcon(),
                ),
              ],
            ),
          ),
          const SpaceH10(),
          if (transactionListItem.withdrawalInfo!.toAddress != null) ...[
            TransactionDetailsItem(
              text: 'Withdrawal to',
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.withdrawalInfo!.toAddress ?? '',
                  ),
                  const SpaceW10(),
                  SIconButton(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: transactionListItem.withdrawalInfo!.toAddress ??
                              '',
                        ),
                      );
                    },
                    defaultIcon: const SCopyIcon(),
                    pressedIcon: const SCopyPressedIcon(),
                  ),
                ],
              ),
            ),
            const SpaceH10(),
          ],
          TransactionDetailsStatus(
            status: transactionListItem.status,
          ),
        ],
      ),
    );
  }
}
