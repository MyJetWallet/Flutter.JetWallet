import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/split_iban.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../../../core/di/di.dart';
import '../../../../../../../../app/store/app_store.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class IbanSendDetails extends StatelessObserverWidget {
  const IbanSendDetails({
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
                        text: (transactionListItem.ibanWithdrawalInfo?.contactName ?? '').trim(),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.46,
                      ),
                      child: TransactionDetailsValueText(
                        textAlign: TextAlign.end,
                        text: splitIban(
                          (transactionListItem.ibanWithdrawalInfo?.toIban ?? '').trim(),
                        ),
                        color: sKit.colors.grey1,
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
                      text: transactionListItem.ibanWithdrawalInfo?.beneficiaryName ??
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
                transactionListItem.ibanWithdrawalInfo?.paymentFeeAssetId ??
                    transactionListItem.ibanWithdrawalInfo?.processingFeeAssetId ??
                    '',
              );

              return PaymentFeeRowWidget(
                fee: (transactionListItem.ibanWithdrawalInfo?.paymentFeeAmount ?? Decimal.zero).toFormatCount(
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
                transactionListItem.ibanWithdrawalInfo?.processingFeeAssetId ??
                    transactionListItem.ibanWithdrawalInfo?.paymentFeeAssetId ??
                    '',
              );

              return ProcessingFeeRowWidget(
                fee: (transactionListItem.ibanWithdrawalInfo?.processingFeeAmount ?? Decimal.zero).toFormatCount(
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
    final asset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.assetId),
        )
        .first;

    return Column(
      children: [
        WhatToWhatConvertWidget(
          removeDefaultPaddings: true,
          isLoading: false,
          fromAssetIconUrl: '',
          fromAssetDescription: transactionListItem.ibanWithdrawalInfo?.accountLabel ?? '',
          fromAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${asset.symbol}'
              : (transactionListItem.ibanWithdrawalInfo?.withdrawalAmount ?? Decimal.zero).abs().toFormatCount(
                    symbol: asset.symbol,
                    accuracy: asset.accuracy,
                  ),
          fromAssetCustomIcon: Assets.svg.other.medium.bankAccount.simpleSvg(
            width: 32,
          ),
          toAssetIconUrl: asset.iconUrl,
          toAssetDescription: asset.description,
          toAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${transactionListItem.ibanWithdrawalInfo?.receiveAsset ?? ''}'
              : (transactionListItem.ibanWithdrawalInfo?.receiveAmount ?? Decimal.zero).toFormatCount(
                  symbol: transactionListItem.ibanWithdrawalInfo?.receiveAsset ?? '',
                  accuracy: asset.accuracy,
                ),
          isError: transactionListItem.status == Status.declined,
          isSmallerVersion: true,
        ),
        const SizedBox(height: 24),
        SBadge(
          status: transactionListItem.status == Status.inProgress
              ? SBadgeStatus.primary
              : transactionListItem.status == Status.completed
                  ? SBadgeStatus.success
                  : SBadgeStatus.error,
          text: transactionDetailsStatusText(transactionListItem.status),
          isLoading: transactionListItem.status == Status.inProgress,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
