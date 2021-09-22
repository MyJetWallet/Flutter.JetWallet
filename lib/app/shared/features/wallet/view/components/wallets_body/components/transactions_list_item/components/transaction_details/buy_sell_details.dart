import 'package:flutter/material.dart';

import '../../../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../../../../service/shared/constants.dart';
import '../../../../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../../helpers/short_address_form.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class BuySellDetails extends StatelessWidget {
  const BuySellDetails({
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
        if (transactionListItem.operationType == OperationType.buy) ...[
          TransactionDetailsItem(
            text: 'With',
            value: TransactionDetailsValueText(
              text: '${'${transactionListItem.swapInfo!.sellAmount}'} '
                  '${transactionListItem.swapInfo!.sellAssetId}',
            ),
          ),
          const SpaceH10(),
          TransactionDetailsItem(
            text: 'Rate',
            value: TransactionDetailsValueText(
              text: '${transactionListItem.swapInfo!.baseRate} '
                  '${transactionListItem.swapInfo!.buyAssetId} = '
                  '${transactionListItem.swapInfo!.quoteRate
                  .toStringAsFixed(signsAfterComma)} '
                  '${transactionListItem.swapInfo!.sellAssetId}',
            ),
          ),
        ],
        if (transactionListItem.operationType == OperationType.sell) ...[
          TransactionDetailsItem(
            text: 'For',
            value: TransactionDetailsValueText(
              text: '${'${transactionListItem.swapInfo!.buyAmount}'} '
                  '${transactionListItem.swapInfo!.buyAssetId}',
            ),
          ),
          const SpaceH10(),
          TransactionDetailsItem(
            text: 'Rate',
            value: TransactionDetailsValueText(
                text:
                    '${transactionListItem.swapInfo!.baseRate}'
                        ' ${transactionListItem.swapInfo!.sellAssetId} = '
                        '${transactionListItem.swapInfo!.quoteRate} '
                        '${transactionListItem.swapInfo!.buyAssetId}',
            ),
          ),
        ],
      ],
    );
  }
}
