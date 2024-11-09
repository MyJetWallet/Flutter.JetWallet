import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_status_badge.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/split_iban.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../core/di/di.dart';
import '../../../app/store/app_store.dart';
import '../../../wallet/helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class BankTransferDetails extends StatelessWidget {
  const BankTransferDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final userInfo = sUserInfo;

    return SPaddingH24(
      child: Column(
        children: [
          IbanSendDetailsHeader(
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
            text: intl.iban_send_history_send_to,
            fromStart: true,
            value: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.46,
                      ),
                      child: TransactionDetailsValueText(
                        textAlign: TextAlign.end,
                        text: splitIban(
                          (transactionListItem.sellWithdrawalInfo?.toIban ?? '').trim(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.iban_send_history_benificiary,
            fromStart: true,
            value: Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SpaceW8(),
                  Flexible(
                    child: TransactionDetailsValueText(
                      text: transactionListItem.sellWithdrawalInfo?.beneficiaryName ??
                          '${userInfo.firstName} ${userInfo.lastName}',
                      textAlign: TextAlign.right,
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
                transactionListItem.sellWithdrawalInfo?.withdrawalAssetId ??
                    transactionListItem.sellCryptoInfo?.feeAssetId ??
                    '',
              );

              final providerFee = ((transactionListItem.sellCryptoInfo?.paymentFeeAmount ?? Decimal.ten) /
                          (transactionListItem.sellCryptoInfo?.quoteRate ?? Decimal.zero))
                      .toDecimal(scaleOnInfinitePrecision: currency.accuracy) +
                  (transactionListItem.sellWithdrawalInfo?.withdrawalFeeAmount ?? Decimal.zero);

              return PaymentFeeRowWidget(
                fee: providerFee.toFormatCount(
                  accuracy: currency.accuracy,
                  symbol: currency.symbol,
                ),
              );
            },
          ),
          const SpaceH18(),
          Builder(
            builder: (context) {
              final currency = currencyFrom(
                sSignalRModules.currenciesWithHiddenList,
                transactionListItem.sellCryptoInfo?.feeAssetId ??
                    transactionListItem.sellCryptoInfo?.paymentFeeAssetId ??
                    '',
              );

              final processingFeeAmount = transactionListItem.sellCryptoInfo?.feeAmount ?? Decimal.zero;

              return ProcessingFeeRowWidget(
                fee: currency.type == AssetType.crypto
                    ? processingFeeAmount.toFormatCount(
                        accuracy: currency.accuracy,
                        symbol: currency.symbol,
                      )
                    : processingFeeAmount.toFormatSum(
                        accuracy: currency.accuracy,
                        symbol: currency.symbol,
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
}

class IbanSendDetailsHeader extends StatelessWidget {
  const IbanSendDetailsHeader({
    super.key,
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final fromAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    ).firstWhere(
      (element) => element.symbol == transactionListItem.sellCryptoInfo?.sellAssetId,
    );

    final toAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    ).firstWhere(
      (element) => element.symbol == transactionListItem.sellWithdrawalInfo?.withdrawalAssetId,
    );

    return Column(
      children: [
        STransaction(
          removeDefaultPaddings: true,
          isLoading: false,
          fromAssetIconUrl: fromAsset.iconUrl,
          fromAssetDescription: fromAsset.description,
          fromAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${fromAsset.symbol}'
              : (transactionListItem.sellCryptoInfo?.sellAmount ?? Decimal.zero).abs().toFormatCount(
                    symbol: fromAsset.symbol,
                    accuracy: fromAsset.accuracy,
                  ),
          toAssetIconUrl: toAsset.iconUrl,
          toAssetDescription: toAsset.description,
          toAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${toAsset.description}'
              : (transactionListItem.sellWithdrawalInfo?.withdrawalAmount ?? Decimal.zero).toFormatCount(
                  symbol: toAsset.symbol,
                  accuracy: toAsset.accuracy,
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
