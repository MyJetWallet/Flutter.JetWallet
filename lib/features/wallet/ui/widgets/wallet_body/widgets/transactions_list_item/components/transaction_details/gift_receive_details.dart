import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../../../utils/formatting/base/volume_format.dart';
import '../../../../../../../../../utils/helpers/currency_from.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class GiftReceiveDetails extends StatelessObserverWidget {
  const GiftReceiveDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      transactionListItem.assetId,
    );

    return SPaddingH24(
      child: Column(
        children: [
          TransactionDetailsItem(
            text: intl.date,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: 'From',
            value: Row(
              children: [
                TransactionDetailsValueText(
                  text: transactionListItem.giftReceiveInfo?.senderName ?? '',
                ),
              ],
            ),
          ),
          const SpaceH14(),
          TransactionDetailsItem(
            text: intl.fee,
            value: Row(
              children: [
                TransactionDetailsValueText(
                  text: volumeFormat(
                    decimal: transactionListItem.withdrawalInfo?.feeAmount ?? Decimal.zero,
                    accuracy: currency.accuracy,
                    symbol: currency.symbol,
                  ),
                ),
              ],
            ),
          ),
          const SpaceH16(),
          TransactionDetailsStatus(
            status: transactionListItem.status,
          ),
          const SpaceH42(),
        ],
      ),
    );
  }
}
