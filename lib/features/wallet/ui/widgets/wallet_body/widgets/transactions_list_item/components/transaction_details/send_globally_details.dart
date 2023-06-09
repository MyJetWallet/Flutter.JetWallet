import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/transaction_details_name_text.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/find_blockchain_by_descr.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class SendGloballyDetails extends StatelessObserverWidget {
  const SendGloballyDetails({
    Key? key,
    required this.transactionListItem,
    required this.onCopyAction,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      transactionListItem.withdrawalInfo?.withdrawalAssetId ?? 'EUR',
    );

    print(transactionListItem);

    return SPaddingH24(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              intl.global_send_payment_details,
              style: sTextH5Style,
            ),
          ),
          const SizedBox(height: 18),
          TransactionDetailsItem(
            text: intl.send_globally_date,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.send_globally_card,
            value: TransactionDetailsValueText(
              text:
                  '•••• ${transactionListItem.withdrawalInfo?.cardLast4 ?? ""}',
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.send_globally_amount_in_eur,
            value: TransactionDetailsValueText(
              text: volumeFormat(
                prefix: currency.prefixSymbol,
                decimal: transactionListItem.withdrawalInfo!.withdrawalAmount,
                accuracy: currency.accuracy,
                symbol: currency.symbol,
              ),
            ),
          ),
          if (transactionListItem.status == Status.completed) ...[
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.send_globally_con_rate,
              value: TransactionDetailsValueText(
                text:
                    '${currency.prefixSymbol}1 = ${transactionListItem.withdrawalInfo!.receiveRate} ${transactionListItem.withdrawalInfo!.receiveAsset}',
              ),
            ),
          ],
          if (transactionListItem.status == Status.completed) ...[
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.send_globally_amount_in_uah,
              value: TransactionDetailsValueText(
                text: volumeFormat(
                  decimal: transactionListItem.withdrawalInfo!.receiveAmount ??
                      Decimal.zero,
                  accuracy: currency.accuracy,
                  symbol: 'UAH',
                ),
              ),
            ),
          ],
          if (transactionListItem.status != Status.declined) ...[
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.send_globally_processing_fee,
              value: TransactionDetailsValueText(
                text: volumeFormat(
                  prefix: currency.prefixSymbol,
                  decimal: transactionListItem.withdrawalInfo!.feeAmount,
                  accuracy: currency.accuracy,
                  symbol: currency.symbol,
                ),
              ),
            ),
          ],
          const SpaceH18(),
          TransactionDetailsStatus(
            status: transactionListItem.status,
          ),
          const SpaceH40(),
        ],
      ),
    );
  }
}
