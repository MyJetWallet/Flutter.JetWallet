import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/card_purchase_details.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/card_refund_details.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/card_withdrawal_details.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/transaction_list_item.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

import '../../../../../../../../../../utils/helpers/check_local_operation.dart';
import '../../../../../../../../helper/is_operation_support_copy.dart';
import '../../../../../../../../helper/nft_types.dart';
import '../../../../../../../../helper/operation_name.dart';

class CommonTransactionDetailsBlock extends StatelessObserverWidget {
  const CommonTransactionDetailsBlock({
    super.key,
    required this.transactionListItem,
    required this.source,
  });

  final OperationHistoryItem transactionListItem;
  final TransactionItemSource source;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final catchingTypes = transactionListItem.operationType == OperationType.nftBuy ||
        transactionListItem.operationType == OperationType.nftSwap ||
        transactionListItem.operationType == OperationType.nftSell;

    final operationWithoutBalanceShow = transactionListItem.operationType == OperationType.cardPurchase ||
        transactionListItem.operationType == OperationType.cardRefund ||
        transactionListItem.operationType == OperationType.cardWithdrawal;

    final isLocal = transactionListItem.operationType == OperationType.cryptoBuy &&
        isOperationLocal(
          transactionListItem.cryptoBuyInfo?.paymentMethod ?? PaymentMethodType.unsupported,
        );

    final currencyForOperation = transactionListItem.operationType == OperationType.nftBuy ||
            transactionListItem.operationType == OperationType.nftSwap
        ? transactionListItem.swapInfo?.sellAssetId ?? ''
        : transactionListItem.operationType == OperationType.nftSell
            ? transactionListItem.swapInfo?.buyAssetId ?? ''
            : transactionListItem.assetId;

    final currency = getIt<FormatService>().findCurrency(
      assetSymbol: currencyForOperation,
      findInHideTerminalList: true,
    );

    final devicePR = MediaQuery.of(context).devicePixelRatio;

    return Column(
      children: [
        SPaddingH24(
          child: _transactionHeader(
            transactionListItem,
            currency,
            context,
            null,
            intl,
          ),
        ),
        if (devicePR == 2) ...[
          const SpaceH30(),
        ] else if (transactionListItem.operationType == OperationType.sendGlobally ||
            ((transactionListItem.operationType == OperationType.p2pBuy || isLocal) &&
                transactionListItem.status == Status.inProgress)) ...[
          const SpaceH40(),
        ] else if (transactionListItem.operationType == OperationType.bankingAccountWithdrawal ||
            transactionListItem.operationType == OperationType.bankingBuy ||
            transactionListItem.operationType == OperationType.cryptoBuy ||
            transactionListItem.operationType == OperationType.swapSell ||
            transactionListItem.operationType == OperationType.swapBuy ||
            transactionListItem.operationType == OperationType.bankingSell ||
            transactionListItem.operationType == OperationType.bankingAccountDeposit ||
            transactionListItem.operationType == OperationType.withdraw ||
            transactionListItem.operationType == OperationType.giftSend ||
            transactionListItem.operationType == OperationType.giftReceive ||
            transactionListItem.operationType == OperationType.rewardPayment ||
            transactionListItem.operationType == OperationType.deposit ||
            transactionListItem.operationType == OperationType.sendGlobally ||
            transactionListItem.operationType == OperationType.cardPurchase ||
            transactionListItem.operationType == OperationType.cardWithdrawal ||
            transactionListItem.operationType == OperationType.cardRefund ||
            transactionListItem.operationType == OperationType.bankingTransfer ||
            transactionListItem.operationType == OperationType.cardBankingSell) ...[
          const SpaceH26(),
        ] else ...[
          const SpaceH67(),
        ],
        if ((transactionListItem.operationType == OperationType.p2pBuy || isLocal) &&
            transactionListItem.status == Status.inProgress)
          Text(
            intl.history_approximately,
            style: sBodyText2Style.copyWith(
              color: colors.grey2,
            ),
          ),
        if (transactionListItem.operationType == OperationType.cardPurchase) ...[
          CardPurchaseDetailsHeader(
            transactionListItem: transactionListItem,
          ),
        ],
        if (transactionListItem.operationType == OperationType.cardRefund) ...[
          CardRefundDetailsHeader(
            transactionListItem: transactionListItem,
          ),
        ],
        if (transactionListItem.operationType == OperationType.cardWithdrawal) ...[
          CardWithdrawalDetailsHeader(
            transactionListItem: transactionListItem,
          ),
        ],
        if (transactionListItem.operationType == OperationType.bankingBuy ||
            transactionListItem.operationType == OperationType.cryptoBuy ||
            transactionListItem.operationType == OperationType.swapSell ||
            transactionListItem.operationType == OperationType.swapBuy ||
            transactionListItem.operationType == OperationType.bankingSell ||
            transactionListItem.operationType == OperationType.bankingAccountWithdrawal ||
            transactionListItem.operationType == OperationType.bankingAccountDeposit ||
            transactionListItem.operationType == OperationType.withdraw ||
            transactionListItem.operationType == OperationType.giftSend ||
            transactionListItem.operationType == OperationType.giftReceive ||
            transactionListItem.operationType == OperationType.rewardPayment ||
            transactionListItem.operationType == OperationType.deposit ||
            transactionListItem.operationType == OperationType.sendGlobally ||
            transactionListItem.operationType == OperationType.bankingTransfer ||
            transactionListItem.operationType == OperationType.cardBankingSell)
          const SizedBox()
        else if ((!nftTypes.contains(transactionListItem.operationType) || catchingTypes) &&
            !operationWithoutBalanceShow) ...[
          SPaddingH24(
            child: AutoSizeText(
              volumeFormat(
                decimal: operationAmount(transactionListItem),
                accuracy: currency.accuracy,
                symbol: currency.symbol,
              ),
              textAlign: TextAlign.center,
              minFontSize: 4.0,
              maxLines: 1,
              strutStyle: const StrutStyle(
                height: 1.20,
                fontSize: 40.0,
                fontFamily: 'Gilroy',
              ),
              style: TextStyle(
                height: 1.20,
                fontSize: 40.0,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
                color: colors.black,
              ),
            ),
          ),
        ],
        if (isOperationSupportCopy(transactionListItem) &&
                transactionListItem.operationType == OperationType.bankingAccountWithdrawal ||
            transactionListItem.operationType == OperationType.bankingBuy ||
            transactionListItem.operationType == OperationType.cryptoBuy ||
            transactionListItem.operationType == OperationType.swapSell ||
            transactionListItem.operationType == OperationType.swapBuy ||
            transactionListItem.operationType == OperationType.bankingSell ||
            transactionListItem.operationType == OperationType.bankingAccountDeposit ||
            transactionListItem.operationType == OperationType.withdraw ||
            transactionListItem.operationType == OperationType.giftSend ||
            transactionListItem.operationType == OperationType.giftReceive ||
            transactionListItem.operationType == OperationType.rewardPayment ||
            transactionListItem.operationType == OperationType.deposit ||
            transactionListItem.operationType == OperationType.sendGlobally ||
            transactionListItem.operationType == OperationType.cardPurchase ||
            transactionListItem.operationType == OperationType.cardWithdrawal ||
            transactionListItem.operationType == OperationType.cardRefund ||
            transactionListItem.operationType == OperationType.bankingTransfer ||
            transactionListItem.operationType == OperationType.cardBankingSell)
          const SizedBox.shrink()
        else
          const SpaceH72(),
      ],
    );
  }

  Widget _transactionHeader(
    OperationHistoryItem transactionListItem,
    CurrencyModel currency,
    BuildContext context,
    String? nftName,
    AppLocalizations intl,
  ) {
    String title;
    if (transactionListItem.operationType == OperationType.simplexBuy) {
      title = '${operationName(OperationType.swapBuy, context)} '
          '${currency.description} - '
          '${operationName(transactionListItem.operationType, context)}';
    } else if (transactionListItem.operationType == OperationType.earningDeposit ||
        transactionListItem.operationType == OperationType.earningWithdrawal) {
      if (transactionListItem.earnInfo?.totalBalance != transactionListItem.balanceChange.abs() &&
          transactionListItem.operationType == OperationType.earningDeposit) {
        title = operationName(
          transactionListItem.operationType,
          context,
          isToppedUp: true,
        );
      }

      title = operationName(transactionListItem.operationType, context);
    } else if (transactionListItem.operationType == OperationType.swapBuy ||
        transactionListItem.operationType == OperationType.swapSell) {
      title = operationName(
        OperationType.swap,
        context,
      );
    } else if (transactionListItem.operationType == OperationType.sendGlobally) {
      title = operationName(
        OperationType.sendGlobally,
        context,
      );
    } else if (transactionListItem.operationType == OperationType.bankingAccountWithdrawal) {
      title = operationName(
        OperationType.bankingAccountWithdrawal,
        context,
      );
    } else if (transactionListItem.operationType == OperationType.giftSend) {
      title = operationName(
        OperationType.giftSend,
        context,
      );
    } else if (transactionListItem.operationType == OperationType.giftReceive) {
      title = operationName(
        OperationType.giftReceive,
        context,
      );
    } else if (transactionListItem.operationType == OperationType.bankingTransfer) {
      if (source == TransactionItemSource.history) {
        title = intl.transferDetails_transfer;
      } else if (transactionListItem.balanceChange > Decimal.zero) {
        title = intl.history_added_cash;
      } else {
        title = intl.history_withdrawn;
      }
    } else {
      title = operationName(
        transactionListItem.operationType,
        context,
        asset: transactionListItem.assetId,
      );
    }

    return SBottomSheetHeader(
      name: title,
    );
  }

  Decimal operationAmount(OperationHistoryItem transactionListItem) {
    if (transactionListItem.operationType == OperationType.withdraw ||
        transactionListItem.operationType == OperationType.bankingAccountWithdrawal ||
        transactionListItem.operationType == OperationType.sendGlobally) {
      return Decimal.tryParse(
            '${transactionListItem.withdrawalInfo?.withdrawalAmount}'.replaceAll('-', ''),
          ) ??
          Decimal.zero;
    }

    if (transactionListItem.operationType == OperationType.transferByPhone) {
      return Decimal.parse(
        '''${transactionListItem.transferByPhoneInfo?.withdrawalAmount ?? Decimal.zero}'''.replaceAll('-', ''),
      );
    }

    return Decimal.parse(
      '${transactionListItem.balanceChange}'.replaceAll('-', ''),
    );
  }

  String getOperationAsset(OperationHistoryItem transactionListItem) {
    if (transactionListItem.operationType == OperationType.withdraw ||
        transactionListItem.operationType == OperationType.bankingAccountWithdrawal ||
        transactionListItem.operationType == OperationType.sendGlobally) {
      return transactionListItem.withdrawalInfo?.withdrawalAssetId ?? '';
    }

    if (transactionListItem.operationType == OperationType.transferByPhone) {
      return transactionListItem.transferByPhoneInfo?.withdrawalAssetId ?? '';
    }

    return transactionListItem.assetId;
  }
}
