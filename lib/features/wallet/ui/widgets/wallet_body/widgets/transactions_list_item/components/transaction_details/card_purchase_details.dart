import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_new_header.dart';
import 'components/transaction_details_new_item.dart';
import 'components/transaction_details_new_value_text.dart';
import 'components/transaction_details_status.dart';

class CardPurchaseDetails extends StatelessObserverWidget {
  const CardPurchaseDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final currenciesFull = sSignalRModules.currenciesWithHiddenList;
    final currentCurrency = currencyFrom(
      currenciesFull,
      transactionListItem.assetId,
    );
    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      transactionListItem.cardPurchaseInfo?.paymentFeeAssetId ??
          'EUR',
    );

    return SPaddingH24(
      child: Column(
        children: [
          TransactionDetailsNewItem(
            text: intl.send_globally_date,
            value: TransactionDetailsNewValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          TransactionDetailsNewItem(
            text: intl.iban_send_history_transaction_id,
            value: Row(
              children: [
                TransactionDetailsNewValueText(
                  text: shortTxhashFrom(transactionListItem.cardPurchaseInfo!.transactionId ?? ''),
                ),
                const SpaceW10(),
                SIconButton(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: transactionListItem.cardPurchaseInfo!.transactionId ?? '',
                      ),
                    );

                    onCopyAction('Txid');
                  },
                  defaultIcon: const SCopyIcon(),
                  pressedIcon: const SCopyPressedIcon(),
                ),
              ],
            ),
          ),
          TransactionDetailsNewItem(
            text: intl.card_history_description,
            value: TransactionDetailsNewValueText(
              text: transactionListItem.cardPurchaseInfo!.description ?? '',
              maxLines: 2,
            ),
          ),
          if (transactionListItem.cardPurchaseInfo!.rate != Decimal.one)
            TransactionDetailsNewItem(
              text: intl.buySellDetails_rate,
              value: TransactionDetailsNewValueText(
                text: '1 EUR = ${transactionListItem.cardPurchaseInfo!.rate} ${currentCurrency.symbol}',
              ),
            ),
          TransactionDetailsNewItem(
            text: intl.buy_confirmation_paid_with,
            value: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: ShapeDecoration(
                    color: sKit.colors.white,
                    shape: OvalBorder(
                      side: BorderSide(
                        color: sKit.colors.grey4,
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: getSimpleNetworkIcon(transactionListItem.cardPurchaseInfo!.cardType),
                  ),
                ),
                const SpaceW8(),
                Text(
                  'Simple ${intl.simple_card_card} '
                      '•• ${transactionListItem.cardPurchaseInfo?.cardLast4}',
                  style: sSubtitle2Style,
                  maxLines: 5,
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) {

              return TransactionDetailsNewItem(
                text: intl.iban_send_history_payment_fee,
                showInfoIcon: true,
                fee: volumeFormat(
                  decimal: transactionListItem.cardPurchaseInfo?.paymentFeeAmount ?? Decimal.zero,
                  accuracy: currency.accuracy,
                  symbol: currency.symbol,
                ),
                value: TransactionDetailsNewValueText(
                  text: volumeFormat(
                    decimal: transactionListItem.cardPurchaseInfo?.paymentFeeAmount ?? Decimal.zero,
                    accuracy: currency.accuracy,
                    symbol: currency.symbol,
                  ),
                ),
              );
            },
          ),
          TransactionDetailsNewItem(
            text: intl.card_history_total_charge,
            value: TransactionDetailsNewValueText(
              text: volumeFormat(
                decimal:
                  (transactionListItem.cardPurchaseInfo?.paymentFeeAmount ??
                      Decimal.zero) + transactionListItem.balanceChange.abs(),
                accuracy: currency.accuracy,
                symbol: currency.symbol,
              ),
            ),
          ),
          if (transactionListItem.status == Status.inProgress)
            Text(
              intl.card_history_purchase_progress,
              style: sCaptionTextStyle.copyWith(
                color: sKit.colors.grey2,
              ),
              maxLines: 5,
            )
          else if (transactionListItem.status == Status.declined)
            Text(
              intl.card_history_purchase_declined,
              style: sCaptionTextStyle.copyWith(
                color: sKit.colors.grey2,
              ),
              maxLines: 5,
            ),
          const SpaceH40(),
        ],
      ),
    );
  }
}

class CardPurchaseDetailsHeader extends StatelessWidget {
  const CardPurchaseDetailsHeader({
    super.key,
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final asset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.withdrawalInfo?.withdrawalAssetId ?? 'EUR'),
        )
        .first;

    return SPaddingH24(
      child: Column(
        children: [
          TransactionNewHeader(
            isLoading: false,
            assetIconUrl: asset.iconUrl,
            assetDescription: asset.description,
            assetValue: volumeFormat(
              symbol: asset.symbol,
              accuracy: asset.accuracy,
              decimal: transactionListItem.balanceChange,
            ),
            // assetBaseAmount
            isError: transactionListItem.status == Status.declined,
          ),
          const SizedBox(height: 24),
          SBadge(
            status: transactionListItem.status == Status.inProgress
                ? SBadgeStatus.pending
                : transactionListItem.status == Status.completed
                    ? SBadgeStatus.success
                    : SBadgeStatus.error,
            text: transactionDetailsStatusText(transactionListItem.status, isPending: true),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

Widget getSimpleNetworkIcon(String? network) {
  switch (network) {
    case 'VISA':
      return const SVisaCardBigIcon(
        width: 12,
        height: 7,
      );
    case 'MASTERCARD':
      return const SMasterCardBigIcon(
        width: 12,
        height: 7,
      );
    default:
      return const SActionDepositIcon();
  }
}
