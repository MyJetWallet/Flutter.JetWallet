import 'package:flutter/material.dart';

import '../../../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../../helpers/short_address_form.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class TransferDetails extends StatelessWidget {
  const TransferDetails({
    Key? key,
    required this.transactionListItem,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TransactionDetailsItem(
          text: 'Transaction ID',
          value: TransactionDetailsValueText(
            text: shortAddressForm(transactionListItem.operationId),
          ),
        ),
        const SpaceH10(),
        TransactionDetailsItem(
          text: 'Transfer to',
          value: TransactionDetailsValueText(
            text: '+${transactionListItem.transferByPhoneInfo!.toPhoneNumber}',
          ),
        ),
        const SpaceH10(),
        TransactionDetailsStatus(
          status: transactionListItem.status,
        ),
      ],
    );
  }
}
