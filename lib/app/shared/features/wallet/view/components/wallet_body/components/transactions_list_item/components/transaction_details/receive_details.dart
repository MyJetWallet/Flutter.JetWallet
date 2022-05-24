import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/operation_history/model/operation_history_response_model.dart';

import '../../../../../../../../../helpers/short_address_form.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class ReceiveDetails extends HookWidget {
  const ReceiveDetails({
    Key? key,
    required this.transactionListItem,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final senderName = transactionListItem.receiveByPhoneInfo!.senderName ?? '';

    return SPaddingH24(
      child: Column(
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
            value: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TransactionDetailsValueText(
                  text:
                      '${transactionListItem.receiveByPhoneInfo!.fromPhoneNumber
                      }',
                ),
                if (senderName.isNotEmpty) ...[
                  Text(
                    senderName,
                    style: sBodyText2Style.copyWith(
                      color: colors.grey1,
                    ),
                  )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
