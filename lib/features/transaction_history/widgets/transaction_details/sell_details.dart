import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_status_badge.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

import '../../../../core/di/di.dart';
import '../../../app/store/app_store.dart';
import '../../../wallet/helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class SellDetails extends StatelessWidget {
  const SellDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final paymentAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.sellCryptoInfo?.sellAssetId ?? 'EUR'),
        )
        .first;

    final buyAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.sellCryptoInfo?.buyAssetId ?? 'EUR'),
        )
        .first;

    return SPaddingH24(
      child: Column(
        children: [
          _SellDetailsHeader(
            transactionListItem: transactionListItem,
          ),
          TransactionDetailsItem(
            text: intl.send_globally_date,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.iban_send_history_transaction_id,
            value: Row(
              children: [
                TransactionDetailsValueText(
                  text: shortTxhashFrom(transactionListItem.operationId),
                ),
                const SpaceW10(),
                HistoryCopyIcon(transactionListItem.operationId),
              ],
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.buy_confirmation_price,
            value: TransactionDetailsValueText(
              text: rateFor(buyAsset, paymentAsset),
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.history_sold_to,
            value: Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SpaceW8(),
                  if (transactionListItem.sellCryptoInfo?.accountType == IbanAccountType.bankCard)
                    Assets.svg.assets.fiat.card.simpleSvg(
                      width: 20,
                    )
                  else
                    Assets.svg.other.medium.bankAccount.simpleSvg(
                      width: 20,
                    ),
                  const SpaceW8(),
                  Flexible(
                    child: TransactionDetailsValueText(
                      text: transactionListItem.sellCryptoInfo?.accountLabel ?? 'Account 1',
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SpaceH18(),
          Builder(
            builder: (context) {
              final currency = currencyFrom(
                sSignalRModules.currenciesWithHiddenList,
                transactionListItem.sellCryptoInfo?.sellAssetId ??
                    transactionListItem.sellCryptoInfo?.sellAssetId ??
                    '',
              );

              return PaymentFeeRowWidget(
                fee: currency.type == AssetType.crypto
                    ? (transactionListItem.sellCryptoInfo?.paymentFeeAmount ?? Decimal.zero).toFormatCount(
                        accuracy: currency.accuracy,
                        symbol: transactionListItem.sellCryptoInfo?.paymentFeeAssetId ?? '',
                      )
                    : (transactionListItem.sellCryptoInfo?.paymentFeeAmount ?? Decimal.zero).toFormatSum(
                        accuracy: currency.accuracy,
                        symbol: transactionListItem.sellCryptoInfo?.paymentFeeAssetId ?? '',
                      ),
              );
            },
          ),
          const SpaceH18(),
          Builder(
            builder: (context) {
              final currency = currencyFrom(
                sSignalRModules.currenciesWithHiddenList,
                transactionListItem.sellCryptoInfo?.paymentFeeAssetId ?? '',
              );

              return ProcessingFeeRowWidget(
                fee: currency.type == AssetType.crypto
                    ? (transactionListItem.sellCryptoInfo?.feeAmount ?? Decimal.zero).toFormatCount(
                        accuracy: currency.accuracy,
                        symbol: transactionListItem.sellCryptoInfo?.feeAssetId ?? '',
                      )
                    : (transactionListItem.sellCryptoInfo?.feeAmount ?? Decimal.zero).toFormatSum(
                        accuracy: currency.accuracy,
                        symbol: transactionListItem.sellCryptoInfo?.feeAssetId ?? '',
                      ),
              );
            },
          ),
          const SpaceH18(),
          const SpaceH40(),
        ],
      ),
    );
  }

  String rateFor(
    CurrencyModel currency1,
    CurrencyModel currency2,
  ) {
    final base = (transactionListItem.sellCryptoInfo?.baseRate ?? Decimal.zero).toFormatPrice(
      prefix: currency1.prefixSymbol,
      accuracy: currency1.accuracy,
    );

    final quote = (transactionListItem.sellCryptoInfo?.quoteRate ?? Decimal.zero).toFormatCount(
      symbol: currency2.symbol,
    );

    return '$base = $quote';
  }
}

class _SellDetailsHeader extends StatelessWidget {
  const _SellDetailsHeader({
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final paymentAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.sellCryptoInfo?.sellAssetId ?? 'EUR'),
        )
        .first;

    final buyAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.sellCryptoInfo?.buyAssetId ?? 'EUR'),
        )
        .first;

    return Column(
      children: [
        STransaction(
          removeDefaultPaddings: true,
          isLoading: false,
          fromAssetIconUrl: paymentAsset.iconUrl,
          fromAssetDescription: paymentAsset.description,
          fromAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${paymentAsset.symbol}'
              : (transactionListItem.sellCryptoInfo?.sellAmount ?? Decimal.zero).toFormatCount(
                  symbol: paymentAsset.symbol,
                  accuracy: paymentAsset.accuracy,
                ),
          toAssetIconUrl: buyAsset.iconUrl,
          toAssetDescription: buyAsset.description,
          toAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${buyAsset.symbol}'
              : (transactionListItem.sellCryptoInfo?.buyAmount ?? Decimal.zero).toFormatCount(
                  symbol: buyAsset.symbol,
                  accuracy: buyAsset.accuracy,
                ),
          isError: transactionListItem.status == Status.declined,
          isSmallerVersion: true,
        ),
        const SizedBox(height: 24),
        TransactionStatusBadge(status: transactionListItem.status),
        const SizedBox(height: 24),
      ],
    );
  }
}

Widget getCardIcon(String? network) {
  switch (network?.toUpperCase()) {
    case 'VISA':
      return const SVisaCardIcon(
        width: 40,
        height: 25,
      );
    case 'MASTER CARD':
      return const SMasterCardIcon(
        width: 40,
        height: 25,
      );
    default:
      return const SActionDepositIcon();
  }
}
