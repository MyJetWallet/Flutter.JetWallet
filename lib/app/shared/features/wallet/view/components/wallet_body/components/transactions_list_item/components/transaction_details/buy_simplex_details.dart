import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/operation_history/model/operation_history_response_model.dart';

import '../../../../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../../../../helpers/short_address_form.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class BuySimplexDetails extends HookWidget {
  const BuySimplexDetails({
    Key? key,
    required this.transactionListItem,
    required this.onCopyAction,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return SPaddingH24(
      child: Column(
        children: [
          TransactionDetailsItem(
            text: '${intl.transaction} ID',
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

                    onCopyAction('${intl.transaction} ID');
                  },
                  defaultIcon: const SCopyIcon(),
                  pressedIcon: const SCopyPressedIcon(),
                ),
              ],
            ),
          ),
          const SpaceH14(),
          TransactionDetailsItem(
            text: intl.withText,
            value: TransactionDetailsValueText(
              text: '\$${transactionListItem.buyInfo!.sellAmount}',
            ),
          ),
          const SpaceH14(),
          TransactionDetailsItem(
            text: intl.buySimplexDetails_payFrom,
            value: TransactionDetailsValueText(
              text: intl.curencyBuy_actionItemName,
            ),
          ),
          const SpaceH14(),
          TransactionDetailsItem(
            text: intl.fee,
            value: TransactionDetailsValueText(
              text: _feeValue(transactionListItem),
            ),
          ),
          const SpaceH16(),
          TransactionDetailsStatus(status: transactionListItem.status),
        ],
      ),
    );
  }

  String _feeValue(OperationHistoryItem transactionListItem) {
    if (transactionListItem.buyInfo != null) {
      if (transactionListItem.buyInfo!.feeAmount > Decimal.zero) {
        return '${transactionListItem.buyInfo!.feeAmount}'
            ' ${transactionListItem.buyInfo!.feeAssetId}';
      } else {
        return '0 ${transactionListItem.buyInfo!.feeAmount}';
      }
    } else {
      return '0';
    }
  }
}
