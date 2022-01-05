import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../../helpers/short_address_form.dart';
import 'components/copy_button.dart';
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
    return Column(
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
                  children: [
                    const TransactionDetailsValueText(
                      text: 'No Fee',
                    ),
                    Text(
                      'Internal transfer',
                      style: TextStyle(
                        fontSize: 12.sp,
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
              const SpaceW4(),
              CopyButton(
                text: transactionListItem.operationId,
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
                  text: shortAddressForm(
                    transactionListItem.withdrawalInfo!.toAddress ?? '',
                  ),
                ),
                const SpaceW4(),
                CopyButton(
                  text: transactionListItem.withdrawalInfo!.toAddress ?? '',
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
    );
  }
}
