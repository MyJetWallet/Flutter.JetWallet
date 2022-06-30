import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/operation_history/model/operation_history_response_model.dart';

import '../../../../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../../../../helpers/short_address_form.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class TransferDetails extends HookWidget {
  const TransferDetails({
    Key? key,
    required this.transactionListItem,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final receiverName =
        transactionListItem.transferByPhoneInfo!.receiverName ?? '';

    return SPaddingH24(
      child: Column(
        children: [
          TransactionDetailsItem(
            text: '${intl.transaction} ID',
            value: TransactionDetailsValueText(
              text: shortAddressForm(transactionListItem.operationId),
            ),
          ),
          const SpaceH10(),
          TransactionDetailsItem(
            text: '${intl.transferDetails_transfer} ${intl.to}',
            value: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TransactionDetailsValueText(
                  text:
                      '${transactionListItem.transferByPhoneInfo!.toPhoneNumber
                      }',
                ),
                if (receiverName.isNotEmpty) ...[
                  Text(
                    receiverName,
                    style: sBodyText2Style.copyWith(color: colors.grey1),
                  )
                ]
              ],
            ),
          ),
          const SpaceH10(),
          TransactionDetailsStatus(
            status: transactionListItem.status,
          ),
          const SpaceH40(),
        ],
      ),
    );
  }
}
