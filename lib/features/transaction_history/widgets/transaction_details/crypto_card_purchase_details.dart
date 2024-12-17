import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/features/home/store/bottom_bar_store.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_status_badge.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

import '../../../../core/di/di.dart';
import '../../../app/store/app_store.dart';
import '../../../wallet/helper/format_date_to_hm.dart';

class CryptoCardPurchaseDetails extends StatelessWidget {
  const CryptoCardPurchaseDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CryptoCardPurchaseDetailsHeader(
          transactionListItem: transactionListItem,
        ),
        TwoColumnCell(
          label: intl.send_globally_date,
          value: '${formatDateToDMY(transactionListItem.timeStamp)}'
              ', ${formatDateToHm(transactionListItem.timeStamp)}',
        ),
        TwoColumnCell(
          label: intl.iban_send_history_transaction_id,
          value: shortTxhashFrom(transactionListItem.cryptoCardPurchaseInfo?.transactionId ?? ''),
          rightValueIcon: HistoryCopyIcon(transactionListItem.operationId),
        ),
        TwoColumnCell(
          label: intl.buySellDetails_rate,
          value:
              '1 ${transactionListItem.cryptoCardPurchaseInfo?.paymentAssetId ?? ''} = ${(transactionListItem.cryptoCardPurchaseInfo?.rate ?? Decimal.zero).toFormatCount(
            symbol: 'EUR',
          )}',
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 42,
            top: 24,
          ),
          child: SButtonContext(
            type: SButtonContextType.iconedMedium,
            text: intl.crypto_card_history_view_full_details,
            icon: Assets.svg.medium.more2,
            onTap: () async {
              sRouter.popUntilRoot();
              getIt<BottomBarStore>().setHomeTab(BottomItemType.cryptoCard);

              await sRouter.push(
                CryptoCardTransactionHistoryRoute(
                  cardId: transactionListItem.cryptoCardPurchaseInfo?.cardId ?? '',
                  operationId: transactionListItem.operationId,
                ),
              );
            },
            expanded: true,
          ),
        ),
      ],
    );
  }
}

class _CryptoCardPurchaseDetailsHeader extends StatelessWidget {
  const _CryptoCardPurchaseDetailsHeader({
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final paymentAsset = getIt<FormatService>().findCurrency(
      assetSymbol: transactionListItem.cryptoCardPurchaseInfo?.paymentAssetId ?? '',
    );

    final fromAmount = transactionListItem.cryptoCardPurchaseInfo?.paymentAmount ?? Decimal.zero;

    return Column(
      children: [
        SPaddingH24(
          child: STransaction(
            removeDefaultPaddings: true,
            isLoading: false,
            fromAssetIconUrl: paymentAsset.iconUrl,
            fromAssetDescription: paymentAsset.description,
            fromAssetValue: getIt<AppStore>().isBalanceHide
                ? '**** ${paymentAsset.symbol}'
                : fromAmount.toFormatCount(
                    symbol: paymentAsset.symbol,
                    accuracy: paymentAsset.accuracy,
                  ),
            hasSecondAsset: false,
            isError: transactionListItem.status == Status.declined,
            isSmallerVersion: true,
          ),
        ),
        const SizedBox(height: 24),
        SPaddingH24(
          child: TransactionStatusBadge(status: transactionListItem.status),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
