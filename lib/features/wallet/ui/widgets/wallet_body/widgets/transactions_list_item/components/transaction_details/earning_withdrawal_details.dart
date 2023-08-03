import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class EarningWithdrawalDetails extends StatelessObserverWidget {
  const EarningWithdrawalDetails({
    Key? key,
    required this.transactionListItem,
    required this.onCopyAction,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final currencies = sSignalRModules.currenciesList;
    final currentCurrency = currencyFrom(
      currencies,
      transactionListItem.assetId,
    );
    final baseCurrency = sSignalRModules.baseCurrency;

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
            text: intl.earn_transaction_id,
            value: Row(
              children: [
                TransactionDetailsValueText(
                  text: shortTxhashFrom(transactionListItem.operationId),
                ),
                const SpaceW10(),
                SIconButton(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: transactionListItem.operationId,
                      ),
                    );

                    onCopyAction('Transaction ID');
                  },
                  defaultIcon: const SCopyIcon(),
                  pressedIcon: const SCopyPressedIcon(),
                ),
              ],
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.earn_remaining_balance,
            value: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TransactionDetailsValueText(
                  text: volumeFormat(
                    decimal: transactionListItem.earnInfo != null &&
                            transactionListItem.earnInfo!.totalBalance !=
                                Decimal.zero &&
                            currentCurrency.currentPrice != Decimal.zero
                        ? Decimal.parse(
                            '${transactionListItem.earnInfo!.totalBalance.toDouble() / currentCurrency.currentPrice.toDouble()}',
                          )
                        : Decimal.zero,
                    accuracy: currentCurrency.accuracy,
                    symbol: currentCurrency.symbol,
                  ),
                ),
                if (transactionListItem.earnInfo!.totalBalance != Decimal.zero)
                  Text(
                    volumeFormat(
                      prefix: baseCurrency.prefix,
                      decimal: transactionListItem.earnInfo?.totalBalance ??
                          Decimal.zero,
                      accuracy: baseCurrency.accuracy,
                      symbol: baseCurrency.symbol,
                    ),
                    style: sBodyText2Style.copyWith(
                      color: colors.grey1,
                    ),
                  ),
              ],
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.earn_details_apy,
            value: TransactionDetailsValueText(
              text: '${transactionListItem.earnInfo?.apy}%',
            ),
          ),
          if (transactionListItem.earnInfo?.withdrawalReason == 'Auto') ...[
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.earn_details_reason,
              value: TransactionDetailsValueText(
                text: intl.earn_details_subscription_expired,
              ),
            ),
          ],
          const SpaceH18(),
          TransactionDetailsStatus(
            status: transactionListItem.status,
          ),
          const SpaceH40(),
          if (transactionListItem.status == Status.inProgress) ...[
            const SpaceH18(),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: colors.grey4,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        bottom: 3,
                      ),
                      child: SErrorIcon(),
                    ),
                    const SpaceW10(),
                    RichText(
                      text: TextSpan(
                        text: intl.earn_in_progress,
                        style: sBodyText1Style.copyWith(
                          color: colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (Platform.isAndroid) const SpaceH24(),
          ],
        ],
      ),
    );
  }
}
