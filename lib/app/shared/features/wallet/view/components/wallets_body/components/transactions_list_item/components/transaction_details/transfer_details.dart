import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../../helpers/short_address_form.dart';
import '../../../../../../../provider/contact_name_for_phone_fpod.dart';
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
    final contactName = useProvider(
      contactNameForPhoneFpod(
        transactionListItem.transferByPhoneInfo!.toPhoneNumber,
      ),
    );

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
          value: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TransactionDetailsValueText(
                text:
                    '+${transactionListItem
                        .transferByPhoneInfo!.toPhoneNumber}',
              ),
              contactName.when(
                data: (String? contactName) {
                  if (contactName != null) {
                    return Text(
                      contactName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  } else if (transactionListItem
                      .transferByPhoneInfo!.receiverName.isNotEmpty) {
                    return Text(
                      transactionListItem.transferByPhoneInfo!.receiverName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            ],
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
