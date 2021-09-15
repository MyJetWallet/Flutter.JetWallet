import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../../../../shared/components/header_text.dart';
import '../../../../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../../../../../../../../../market_details/helper/currency_from.dart';
import '../../../../../../../../helper/operation_name.dart';

class CommonTransactionDetailsBlock extends HookWidget {
  const CommonTransactionDetailsBlock({
    Key? key,
    required this.transactionListItem,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final asset = currencyFrom(
      useProvider(currenciesPod),
      transactionListItem.assetId,
    );

    return Column(
      children: [
        HeaderText(
          text:
              '${operationName(transactionListItem.operationType)} '
                  '${asset.description}',
          textAlign: TextAlign.center,
        ),
        const SpaceH75(),
        Text(
          DateFormat('EEEE, MMMM d, y').format(
            DateTime.parse('${transactionListItem.timeStamp}Z').toLocal(),
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12.sp,
          ),
        ),
        Text(
          '${transactionListItem.balanceChange} '
          '${transactionListItem.assetId}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SpaceH96(),
      ],
    );
  }
}
