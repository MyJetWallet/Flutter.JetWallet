import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/prepaid_card/utils/show_commision_explanation_bottom_sheet.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_status_badge.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../core/di/di.dart';
import '../../../app/store/app_store.dart';
import '../../../wallet/helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class BuyVouncherDetails extends StatelessWidget {
  const BuyVouncherDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final buyAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    ).firstWhere(
      (element) => element.symbol == transactionListItem.mobileGiftCardOperationInfo?.mobileCardAsset,
      orElse: () => CurrencyModel.empty(),
    );

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
            text: intl.prepaid_card_card_type,
            fromStart: true,
            value: Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SpaceW8(),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child:
                        (transactionListItem.mobileGiftCardOperationInfo?.mobileCardProduct?.contains('Mastercard') ??
                                false)
                            ? Assets.svg.other.medium.mastercard.simpleSvg(
                                width: 20,
                                height: 20,
                              )
                            : Assets.svg.other.medium.visa.simpleSvg(
                                width: 20,
                                height: 20,
                              ),
                  ),
                  const SpaceW8(),
                  Flexible(
                    child: TransactionDetailsValueText(
                      text: transactionListItem.mobileGiftCardOperationInfo?.mobileCardProduct ?? '',
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (transactionListItem.status != Status.declined) ...[
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.prepaid_card_card_balance,
              value: TransactionDetailsValueText(
                text: getIt<AppStore>().isBalanceHide
                    ? '**** ${transactionListItem.mobileGiftCardOperationInfo?.mobileCardAsset ?? ''}'
                    : (transactionListItem.mobileGiftCardOperationInfo?.mobileCardBalance ?? Decimal.zero)
                        .toFormatCount(
                        symbol: transactionListItem.mobileGiftCardOperationInfo?.mobileCardAsset ?? '',
                        accuracy: buyAsset.accuracy,
                      ),
              ),
            ),
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.prepaid_card_order_id,
              value: Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: TransactionDetailsValueText(
                        text: shortTxhashFrom(
                          transactionListItem.mobileGiftCardOperationInfo?.mobileCardOrderId ?? '',
                        ),
                        maxLines: 1,
                      ),
                    ),
                    const SpaceW10(),
                    HistoryCopyIcon(
                      transactionListItem.mobileGiftCardOperationInfo?.mobileCardOrderId ?? '',
                    ),
                  ],
                ),
              ),
            ),
            const SpaceH8(),
            TwoColumnCell(
              label: intl.prepaid_card_commission,
              value: getIt<AppStore>().isBalanceHide
                  ? '**** ${transactionListItem.assetId}'
                  : Decimal.zero.toFormatCount(
                      symbol: transactionListItem.assetId,
                    ),
              needHorizontalPadding: false,
              haveInfoIcon: true,
              onTab: () {
                showCommisionExplanationBottomSheet(context);
              },
            ),
          ],
          if (transactionListItem.status == Status.completed)
            Padding(
              padding: const EdgeInsets.only(
                top: 24,
              ),
              child: SButtonContext(
                type: SButtonContextType.iconedMedium,
                text: intl.prepaid_card_issue_card,
                icon: Assets.svg.medium.card,
                onTap: () async {
                  await sRouter.push(
                    PrepaidCardDetailsRouter(
                      orderId: transactionListItem.mobileGiftCardOperationInfo?.mobileCardOrderId ?? '',
                    ),
                  );
                },
                expanded: true,
              ),
            ),
          const SpaceH45(),
        ],
      ),
    );
  }
}

class _SellDetailsHeader extends StatelessWidget {
  const _SellDetailsHeader({
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final asset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    ).firstWhere(
      (element) => element.symbol == transactionListItem.assetId,
      orElse: () => CurrencyModel.empty(),
    );

    final buyAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    ).firstWhere(
      (element) => element.symbol == transactionListItem.mobileGiftCardOperationInfo?.mobileCardAsset,
      orElse: () => CurrencyModel.empty(),
    );

    return Column(
      children: [
        STransaction(
          removeDefaultPaddings: true,
          isLoading: false,
          fromAssetIconUrl: asset.iconUrl,
          fromAssetDescription: asset.description,
          fromAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${asset.symbol}'
              : (transactionListItem.mobileGiftCardOperationInfo?.mobileCardBalance?.abs() ?? Decimal.zero)
                  .toFormatCount(
                  symbol: asset.symbol,
                  accuracy: asset.accuracy,
                ),
          toAssetIconUrl: buyAsset.iconUrl,
          toAssetDescription: intl.prepaid_card_prepaid_card_voucher,
          toAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${asset.symbol}'
              : (transactionListItem.mobileGiftCardOperationInfo?.mobileCardBalance?.abs() ?? Decimal.zero)
                  .toFormatCount(
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
