import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/send_gift/widgets/share_gift_result_bottom_sheet.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/components/transaction_details_status.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:simple_kit/modules/shared/stack_loader/stack_loader.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../utils/helpers/currency_from.dart';
import '../../../app/store/app_store.dart';
import '../../../wallet/helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class GiftSendDetails extends StatelessObserverWidget {
  GiftSendDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  final store = StackLoaderStore();

  @override
  Widget build(BuildContext context) {
    final receiverContact =
        transactionListItem.giftSendInfo?.toEmail ?? transactionListItem.giftSendInfo?.toPhoneNumber ?? '';
    final currency = currencyFrom(
      sSignalRModules.currenciesWithHiddenList,
      transactionListItem.assetId,
    );

    return StackLoader(
      loaderText: intl.register_pleaseWait,
      loading: store,
      child: SPaddingH24(
        child: Column(
          children: [
            _GiftSendDetailsHeader(
              transactionListItem: transactionListItem,
            ),
            TransactionDetailsItem(
              text: intl.date,
              value: TransactionDetailsValueText(
                text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                    ', ${formatDateToHm(transactionListItem.timeStamp)}',
              ),
            ),
            const SpaceH16(),
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
            const SpaceH16(),
            TransactionDetailsItem(
              text: intl.gift_history_to,
              value: Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SpaceW10(),
                    Flexible(
                      child: TransactionDetailsValueText(
                        textAlign: TextAlign.right,
                        text: receiverContact,
                      ),
                    ),
                    const SpaceW10(),
                    HistoryCopyIcon(receiverContact),
                  ],
                ),
              ),
            ),
            const SpaceH16(),
            ProcessingFeeRowWidget(
              fee: (transactionListItem.giftSendInfo?.processingFeeAmount ?? Decimal.zero).toFormatCount(
                accuracy: currency.accuracy,
                symbol: transactionListItem.giftSendInfo?.processingFeeAssetId ?? '',
              ),
            ),
            if (transactionListItem.status == Status.inProgress) ...[
              const SpaceH40(),
              SPrimaryButton1(
                active: true,
                name: intl.gift_history_remind,
                onTap: () {
                  shareGiftResultBottomSheet(
                    context: context,
                    amount: Decimal.parse(
                      '${transactionListItem.balanceChange}'.replaceAll('-', ''),
                    ),
                    currency: currency,
                    email: transactionListItem.giftSendInfo?.toEmail,
                    phoneNumber: transactionListItem.giftSendInfo?.toPhoneNumber,
                    onClose: () {},
                  );
                },
              ),
              const SpaceH10(),
              STextButton1(
                active: true,
                name: intl.gift_history_cancel_transaction,
                onTap: () {
                  sShowAlertPopup(
                    context,
                    primaryText: '${intl.gift_history_cancel_transaction}?',
                    secondaryText: intl.gift_history_are_you_sure,
                    primaryButtonName: intl.gift_history_yes_cancel,
                    secondaryButtonName: intl.gift_history_no,
                    primaryButtonType: SButtonType.primary3,
                    onPrimaryButtonTap: () async {
                      store.startLoadingImmediately();
                      Navigator.pop(context);
                      await getIt.get<SNetwork>().simpleNetworking.getWalletModule().cancelGift(
                            transactionListItem.giftSendInfo?.transferId ?? '',
                          );
                      store.finishLoading();
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    onSecondaryButtonTap: () => Navigator.pop(context),
                  );
                },
              ),
            ],
            const SpaceH42(),
          ],
        ),
      ),
    );
  }
}

class _GiftSendDetailsHeader extends StatelessWidget {
  const _GiftSendDetailsHeader({
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final paymentAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.assetId),
        )
        .first;

    final buyAsset = nonIndicesWithBalanceFrom(
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
          isSmallerVersion: true,
          fromAssetIconUrl: paymentAsset.iconUrl,
          fromAssetDescription: paymentAsset.description,
          fromAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${paymentAsset.symbol}'
              : transactionListItem.balanceChange.abs().toFormatCount(
                    symbol: paymentAsset.symbol,
                    accuracy: paymentAsset.accuracy,
                  ),
          toAssetIconUrl: buyAsset.iconUrl,
          toAssetDescription: buyAsset.description,
          toAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${buyAsset.symbol}'
              : (transactionListItem.giftSendInfo?.receiveAmount ?? Decimal.zero).abs().toFormatCount(
                    symbol: buyAsset.symbol,
                    accuracy: buyAsset.accuracy,
                  ),
          isError: transactionListItem.status == Status.declined,
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
