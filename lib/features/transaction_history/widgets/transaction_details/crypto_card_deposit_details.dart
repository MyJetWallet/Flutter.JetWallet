import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/home/store/bottom_bar_store.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_status_badge.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

import '../../../../core/di/di.dart';
import '../../../app/store/app_store.dart';
import '../../../wallet/helper/format_date_to_hm.dart';

class CryptoCardDepositDetails extends StatelessWidget {
  const CryptoCardDepositDetails({
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
        _CryptoCardDepositDetailsHeader(
          transactionListItem: transactionListItem,
        ),
        TwoColumnCell(
          label: intl.send_globally_date,
          value: '${formatDateToDMY(transactionListItem.timeStamp)}'
              ', ${formatDateToHm(transactionListItem.timeStamp)}',
        ),
        TwoColumnCell(
          label: intl.iban_send_history_transaction_id,
          value: shortTxhashFrom(transactionListItem.cryptoCardDepositInfo?.transactionId ?? ''),
          rightValueIcon: HistoryCopyIcon(transactionListItem.operationId),
        ),
        TwoColumnCell(
          label: intl.buySellDetails_rate,
          value:
              '1 ${transactionListItem.cryptoCardDepositInfo?.receiveAssetId ?? ''} = ${(transactionListItem.cryptoCardDepositInfo?.rate ?? Decimal.zero).toFormatCount(
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
                  cardId: transactionListItem.cryptoCardDepositInfo?.cardId ?? '',
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

class _CryptoCardDepositDetailsHeader extends StatelessWidget {
  const _CryptoCardDepositDetailsHeader({
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final euroAsset = getIt<FormatService>().findCurrency(
      assetSymbol: 'EUR',
    );

    final receiveAsset = getIt<FormatService>().findCurrency(
      assetSymbol: transactionListItem.cryptoCardDepositInfo?.receiveAssetId ?? '',
    );

    final formatService = getIt.get<FormatService>();
    final fromAmount = formatService.convertOneCurrencyToAnotherOne(
      fromCurrency: receiveAsset.symbol,
      fromCurrencyAmmount: transactionListItem.cryptoCardDepositInfo?.receiveAmount ?? Decimal.zero,
      toCurrency: euroAsset.symbol,
      baseCurrency: sSignalRModules.baseCurrency.symbol,
      isMin: false,
    );

    return Column(
      children: [
        SPaddingH24(
          child: STransaction(
            removeDefaultPaddings: true,
            isLoading: false,
            fromAssetIconUrl: euroAsset.iconUrl,
            fromAssetDescription: euroAsset.description,
            fromAssetValue: getIt<AppStore>().isBalanceHide
                ? '**** ${euroAsset.symbol}'
                : fromAmount.toFormatCount(
                    symbol: euroAsset.symbol,
                    accuracy: euroAsset.accuracy,
                  ),
            toAssetIconUrl: receiveAsset.iconUrl,
            toAssetDescription: receiveAsset.description,
            toAssetValue: getIt<AppStore>().isBalanceHide
                ? '**** ${receiveAsset.symbol}'
                : (transactionListItem.cryptoCardDepositInfo?.receiveAmount ?? Decimal.zero).toFormatCount(
                    symbol: receiveAsset.symbol,
                    accuracy: receiveAsset.accuracy,
                  ),
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
