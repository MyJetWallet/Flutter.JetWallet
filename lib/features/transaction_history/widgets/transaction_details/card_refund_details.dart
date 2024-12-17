import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_status_badge.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

import '../../../../core/di/di.dart';
import '../../../app/store/app_store.dart';
import '../../../wallet/helper/format_date_to_hm.dart';
import 'components/transaction_details_new_header.dart';
import 'components/transaction_details_new_item.dart';
import 'components/transaction_details_new_value_text.dart';

class CardRefundDetails extends StatelessWidget {
  const CardRefundDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final currency = currencyFrom(
      sSignalRModules.currenciesWithHiddenList,
      transactionListItem.cardRefundInfo?.paymentFeeAssetId ?? 'EUR',
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
                  text: shortTxhashFrom(
                    transactionListItem.cardRefundInfo!.transactionId ?? '',
                  ),
                ),
                const SpaceW10(),
                HistoryCopyIcon(
                  transactionListItem.cardRefundInfo!.transactionId ?? '',
                ),
              ],
            ),
          ),
          TransactionDetailsNewItem(
            text: intl.card_history_description,
            value: TransactionDetailsNewValueText(
              text: transactionListItem.cardRefundInfo!.description ?? '',
              maxLines: 2,
            ),
          ),
          if (transactionListItem.cardRefundInfo!.paymentAssetId != 'EUR')
            TransactionDetailsNewItem(
              text: intl.buySellDetails_rate,
              value: TransactionDetailsNewValueText(
                text:
                    '1 ${transactionListItem.cardRefundInfo!.rateBaseAsset} = ${transactionListItem.cardRefundInfo!.rate} ${transactionListItem.cardRefundInfo!.rateQuoteAsset}',
              ),
            ),
          TransactionDetailsNewItem(
            text: intl.card_history_credited_to,
            value: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: ShapeDecoration(
                    color: SColorsLight().white,
                    shape: OvalBorder(
                      side: BorderSide(
                        color: SColorsLight().gray4,
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: getSimpleNetworkIcon(
                      transactionListItem.cardRefundInfo!.cardType,
                    ),
                  ),
                ),
                const SpaceW8(),
                Text(
                  'Simple ${intl.simple_card_card} '
                  '•• ${transactionListItem.cardRefundInfo?.cardLast4}',
                  style: STStyles.subtitle1,
                  maxLines: 5,
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) {
              return TransactionDetailsNewItem(
                text: intl.provider_fee,
                showInfoIcon: true,
                fee: (transactionListItem.cardRefundInfo?.paymentFeeAmount ?? Decimal.zero).toFormatSum(
                  accuracy: currency.accuracy,
                  symbol: currency.symbol,
                ),
                value: TransactionDetailsNewValueText(
                  text: (transactionListItem.cardRefundInfo?.paymentFeeAmount ?? Decimal.zero).toFormatSum(
                    accuracy: currency.accuracy,
                    symbol: currency.symbol,
                  ),
                ),
              );
            },
          ),
          TransactionDetailsNewItem(
            text: intl.card_history_total_refund,
            value: TransactionDetailsNewValueText(
              text: getIt<AppStore>().isBalanceHide
                  ? '**** ${currency.symbol}'
                  : ((transactionListItem.cardRefundInfo?.paymentFeeAmount ?? Decimal.zero) +
                          transactionListItem.balanceChange.abs())
                      .toFormatCount(
                      accuracy: currency.accuracy,
                      symbol: currency.symbol,
                    ),
            ),
          ),
          const SpaceH40(),
        ],
      ),
    );
  }
}

class CardRefundDetailsHeader extends StatelessWidget {
  const CardRefundDetailsHeader({
    super.key,
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final eurAsset = sSignalRModules.currenciesWithHiddenList.firstWhere(
      (element) => element.symbol == 'EUR',
      orElse: () => CurrencyModel.empty(),
    );

    return SPaddingH24(
      child: Column(
        children: [
          TransactionNewHeader(
            isLoading: false,
            assetIconUrl: eurAsset.iconUrl,
            assetDescription: eurAsset.description,
            assetValue: getIt<AppStore>().isBalanceHide
                ? '**** ${eurAsset.symbol}'
                : transactionListItem.balanceChange.toFormatCount(
                    symbol: 'EUR',
                  ),
            assetBaseAmount: transactionListItem.cardRefundInfo?.paymentAssetId != 'EUR'
                ? getIt<AppStore>().isBalanceHide
                    ? '**** ${transactionListItem.cardRefundInfo?.paymentAssetId}'
                    : (transactionListItem.cardRefundInfo?.paymentAmount ?? Decimal.zero).toFormatCount(
                        symbol: transactionListItem.cardRefundInfo?.paymentAssetId ?? '',
                      )
                : null,
            isError: transactionListItem.status == Status.declined,
          ),
          const SizedBox(height: 24),
          TransactionStatusBadge(status: transactionListItem.status),
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
