import 'package:flutter/material.dart';

import '../../../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../../helpers/short_address_form.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class ReceiveDetails extends StatelessWidget {
  const ReceiveDetails({
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
          text: 'Transfer from',
          value: TransactionDetailsValueText(
            text: '+${transactionListItem.receiveByPhoneInfo!.fromPhoneNumber}',
          ),
        ),
      ],
    );
  }
}
