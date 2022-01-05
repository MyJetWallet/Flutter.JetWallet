import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../../../providers/currencies_pod/currencies_pod.dart';
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
    final colors = useProvider(sColorPod);
    final asset = currencyFrom(
      useProvider(currenciesPod),
      transactionListItem.assetId,
    );

    return Column(
      children: [
        Text(
          '${operationName(transactionListItem.operationType)} '
          '${asset.description}',
          style: sTextH5Style,
        ),
        const SpaceH67(),
        Text(
          '${transactionListItem.balanceChange} '
          '${transactionListItem.assetId}',
          style: sTextH1Style,
        ),
        Text(
          DateFormat('EEEE, MMMM d, y').format(
            DateTime.parse('${transactionListItem.timeStamp}Z').toLocal(),
          ),
          style: sBodyText2Style.copyWith(color: colors.grey2),
        ),
        const SpaceH72(),
      ],
    );
  }
}
