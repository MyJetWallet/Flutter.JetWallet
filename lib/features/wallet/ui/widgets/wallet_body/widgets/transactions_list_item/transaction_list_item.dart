import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/16x16/public/gift_history/simple_gift_history_icon.dart';
import 'package:simple_kit/modules/icons/16x16/public/reward_history/simple_reward_history_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/add_cash/simple_add_cash_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/transfer/simple_transfer_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/withdrawal/simple_withdrawal_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../core/di/di.dart';
import '../../../../../../app/store/app_store.dart';
import '../../../../../helper/format_date_to_hm.dart';
import '../../../../../helper/show_transaction_details.dart';
import 'components/transaction_list_item_header_text.dart';
import 'components/transaction_list_item_text.dart';

enum TransactionItemSource {
  history,
  cryptoAccount,
  eurAccount,
  simpleCard,
}

class TransactionListItem extends StatelessWidget {
  TransactionListItem({
    super.key,
    required this.transactionListItem,
    required this.source,
    this.onItemTapLisener,
    this.fromCJAccount = false,
  }) {
    isEurAccount = source == TransactionItemSource.eurAccount;
  }

  final OperationHistoryItem transactionListItem;
  final void Function(String assetSymbol)? onItemTapLisener;
  final bool fromCJAccount;
  final TransactionItemSource source;

  late final bool isEurAccount;

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesWithHiddenList;
    final currency = currencyFrom(
      currencies,
      transactionListItem.assetId,
    );

    final paymentCurrency = transactionListItem.buyInfo?.sellAssetId != null
        ? currencyFrom(
            currencies,
            transactionListItem.buyInfo!.sellAssetId,
          )
        : currencies[0];
    final baseCurrency = sSignalRModules.baseCurrency;

    return TransactionBaseItem(
      onTap: () {
        if (fromCJAccount) {
          sAnalytics.eurWalletTapAnyHistoryTRXEUR(
            isCJ: true,
            isHasTransaction: true,
            eurAccountLabel: '',
          );
        }

        onItemTapLisener?.call(transactionListItem.assetId);
        showTransactionDetails(
          context: context,
          transactionListItem: transactionListItem,
          source: source,
        );
      },
      icon: _transactionItemIcon(
        type: transactionListItem.operationType,
        isFailed: transactionListItem.status == Status.declined,
        transactionListItem: transactionListItem,
      ),
      labele: _transactionItemTitle(
        transactionListItem,
      ),
      labelIcon: _transactionLabelIcon(
        type: transactionListItem.operationType,
      ),
      balanceChange: getIt<AppStore>().isBalanceHide
          ? '**** ${currency.symbol}'
          : _transactionItemBalanceChange(
              transactionListItem: transactionListItem,
              accuracy: currency.accuracy,
              symbol: currency.symbol,
            ),
      status: transactionListItem.status,
      timeStamp: transactionListItem.timeStamp,
      rightSupplement: _transactionItemRightSupplement(
        transactionListItem: transactionListItem,
        currency: currency,
        baseCurrency: baseCurrency,
        paymentCurrency: paymentCurrency,
      ),
    );
  }

  String _transactionItemTitle(
    OperationHistoryItem transactionListItem,
  ) {
    switch (transactionListItem.operationType) {
      case OperationType.swapBuy:
      case OperationType.swapSell:
        return '${transactionListItem.swapInfo?.sellAssetId} ${intl.operationName_exchangeTo} ${transactionListItem.swapInfo?.buyAssetId}';
      case OperationType.cryptoBuy:
        return '${transactionListItem.cryptoBuyInfo?.paymentAssetId} ${intl.operationName_exchangeTo} ${transactionListItem.cryptoBuyInfo?.buyAssetId}';
      case OperationType.bankingBuy:
        return '${transactionListItem.cryptoBuyInfo?.paymentAssetId} ${intl.operationName_exchangeTo} ${transactionListItem.cryptoBuyInfo?.buyAssetId}';
      case OperationType.bankingSell:
      case OperationType.cardBankingSell:
        return '${transactionListItem.sellCryptoInfo?.sellAssetId} ${intl.operationName_exchangeTo} ${transactionListItem.sellCryptoInfo?.buyAssetId}';
      default:
        return transactionListItem.assetId;
    }
  }

  Widget _transactionItemIcon({
    required OperationType type,
    required bool isFailed,
    required OperationHistoryItem transactionListItem,
  }) {
    final colors = sKit.colors;
    final failedColor = colors.grey2;
    switch (type) {
      case OperationType.deposit:
        return SReceiveByPhoneIcon(color: isFailed ? failedColor : null);
      case OperationType.withdraw:
        return SSendByPhoneIcon(color: isFailed ? failedColor : null);
      case OperationType.transferByPhone:
        return SSendByPhoneIcon(color: isFailed ? failedColor : null);
      case OperationType.receiveByPhone:
        return SReceiveByPhoneIcon(color: isFailed ? failedColor : null);
      case OperationType.ibanDeposit:
        return SReceiveByPhoneIcon(color: isFailed ? failedColor : null);
      case OperationType.p2pBuy:
        return SPlusIcon(color: isFailed ? failedColor : null);
      case OperationType.swapBuy:
        return STransferIcon(color: isFailed ? failedColor : colors.blue);
      case OperationType.swapSell:
        return STransferIcon(color: isFailed ? failedColor : colors.blue);
      case OperationType.paidInterestRate:
        return SPlusIcon(color: isFailed ? failedColor : null);
      case OperationType.feeSharePayment:
        return SPlusIcon(color: isFailed ? failedColor : null);
      case OperationType.withdrawalFee:
        return SMinusIcon(color: isFailed ? failedColor : null);
      case OperationType.swap:
        return const SActionConvertIcon();
      case OperationType.rewardPayment:
        return SReceiveByPhoneIcon(color: isFailed ? failedColor : null);
      case OperationType.simplexBuy:
        return SPlusIcon(color: isFailed ? failedColor : null);
      case OperationType.recurringBuy:
        return SPlusIcon(color: isFailed ? failedColor : null);
      case OperationType.earningWithdrawal:
        return SPlusIcon(color: isFailed ? failedColor : null);
      case OperationType.earningDeposit:
        return SMinusIcon(color: isFailed ? failedColor : null);
      case OperationType.unknown:
        return const SizedBox();
      case OperationType.cryptoBuy:
        return SPlusIcon(color: isFailed ? failedColor : null);
      case OperationType.buyApplePay:
        return SPlusIcon(color: isFailed ? failedColor : null);
      case OperationType.buyGooglePay:
        return SPlusIcon(color: isFailed ? failedColor : null);
      case OperationType.ibanSend:
        return SSendByPhoneIcon(color: isFailed ? failedColor : null);
      case OperationType.sendGlobally:
        return SNetworkIcon(color: isFailed ? failedColor : null);
      case OperationType.giftSend:
        return SSendByPhoneIcon(color: isFailed ? failedColor : null);
      case OperationType.giftReceive:
        return SReceiveByPhoneIcon(color: isFailed ? failedColor : null);
      case OperationType.bankingBuy:
        return isEurAccount
            ? SMinusIcon(color: isFailed ? failedColor : null)
            : SPlusIcon(color: isFailed ? failedColor : null);
      case OperationType.bankingAccountDeposit:
        return SAddCashIcon(
          color: isFailed ? failedColor : colors.green,
        );
      case OperationType.bankingAccountWithdrawal:
        return SWithdrawalIcon(
          color: isFailed ? failedColor : colors.red,
        );
      case OperationType.cardRefund:
        return SRefundIcon(color: isFailed ? failedColor : colors.blue);
      case OperationType.cardPurchase:
        return SPurchaseIcon(color: isFailed ? failedColor : colors.red);
      case OperationType.cardWithdrawal:
        return SWithdrawalIcon(color: isFailed ? failedColor : colors.red);
      case OperationType.bankingSell:
      case OperationType.cardBankingSell:
        return source == TransactionItemSource.cryptoAccount
            ? SMinusIcon(color: isFailed ? failedColor : null)
            : SPlusIcon(color: isFailed ? failedColor : null);
      case OperationType.bankingTransfer:
        return source == TransactionItemSource.history
            ? Assets.svg.medium.altDeposit.simpleSvg(
                width: 24,
                color: isFailed ? failedColor : colors.blue,
              )
            : transactionListItem.balanceChange > Decimal.zero
                ? Assets.svg.medium.addCash.simpleSvg(
                    width: 24,
                    color: isFailed ? failedColor : colors.green,
                  )
                : Assets.svg.medium.withdrawal.simpleSvg(
                    width: 24,
                    color: isFailed ? failedColor : colors.red,
                  );
      case OperationType.earnReserve:
        return SPlusIcon(color: isFailed ? failedColor : null);
      case OperationType.earnSend:
        return SMinusIcon(color: isFailed ? failedColor : null);
      case OperationType.cardTransfer:
        return source == TransactionItemSource.history
            ? Assets.svg.medium.altDeposit.simpleSvg(
                width: 24,
                color: isFailed ? failedColor : colors.blue,
              )
            : transactionListItem.balanceChange > Decimal.zero
                ? Assets.svg.medium.addCash.simpleSvg(
                    width: 24,
                    color: isFailed ? failedColor : colors.green,
                  )
                : Assets.svg.medium.withdrawal.simpleSvg(
                    width: 24,
                    color: isFailed ? failedColor : colors.red,
                  );
      case OperationType.buyPrepaidCard:
        return Assets.svg.medium.arrowUp.simpleSvg(
          width: 24,
          color: isFailed ? failedColor : colors.red,
        );
      default:
        return SPlusIcon(color: isFailed ? failedColor : null);
    }
  }

  Widget? _transactionLabelIcon({
    required OperationType type,
  }) {
    switch (type) {
      case OperationType.giftSend:
      case OperationType.giftReceive:
        return const SGiftHistoryIcon();
      case OperationType.rewardPayment:
        return const SRewardHistoryIcon();
      default:
        return null;
    }
  }

  String _transactionItemBalanceChange({
    required OperationHistoryItem transactionListItem,
    required String symbol,
    required int accuracy,
  }) {
    final amount = (transactionListItem.operationType == OperationType.ibanSend ||
            transactionListItem.operationType == OperationType.transferByPhone ||
            transactionListItem.operationType == OperationType.giftSend ||
            ((transactionListItem.operationType == OperationType.bankingTransfer) &&
                (source == TransactionItemSource.history)))
        ? transactionListItem.balanceChange.abs()
        : transactionListItem.balanceChange;

    return volumeFormat(
      decimal: amount,
      accuracy: accuracy,
      symbol: symbol,
    );
  }

  String? _transactionItemRightSupplement({
    required OperationHistoryItem transactionListItem,
    required CurrencyModel currency,
    required CurrencyModel paymentCurrency,
    required BaseCurrencyModel baseCurrency,
  }) {
    if (transactionListItem.operationType == OperationType.swapSell) {
      return '${intl.transactionListItem_forText} '
          '${getIt<AppStore>().isBalanceHide ? '**** ${transactionListItem.swapInfo?.buyAssetId ?? ''}' : volumeFormat(
              decimal: transactionListItem.swapInfo!.buyAmount,
              symbol: transactionListItem.swapInfo!.buyAssetId,
            )}';
    }
    if (transactionListItem.operationType == OperationType.swapBuy) {
      return '${intl.history_with} ${getIt<AppStore>().isBalanceHide ? '**** ${transactionListItem.swapInfo?.sellAssetId ?? ''}' : volumeFormat(
          decimal: transactionListItem.swapInfo!.sellAmount,
          symbol: transactionListItem.swapInfo!.sellAssetId ?? '',
        )}';
    }
    if (transactionListItem.operationType == OperationType.simplexBuy) {
      return '${intl.history_with} '
          '${getIt<AppStore>().isBalanceHide ? '**** ${transactionListItem.swapInfo?.sellAssetId ?? ''}' : volumeFormat(
              decimal: transactionListItem.buyInfo!.sellAmount,
              symbol: transactionListItem.buyInfo!.sellAssetId,
            )}';
    }
    if (transactionListItem.operationType == OperationType.recurringBuy) {
      return '${intl.history_with} ${getIt<AppStore>().isBalanceHide ? '**** ${transactionListItem.recurringBuyInfo?.sellAssetId ?? ''}' : volumeFormat(
          decimal: transactionListItem.recurringBuyInfo!.sellAmount,
          symbol: transactionListItem.recurringBuyInfo!.sellAssetId!,
        )}';
    }
    if (transactionListItem.operationType == OperationType.earningDeposit &&
        transactionListItem.earnInfo?.totalBalance == transactionListItem.balanceChange.abs()) {
      return ' ${getIt<AppStore>().isBalanceHide ? '**** ${baseCurrency.symbol}' : volumeFormat(
          decimal: transactionListItem.earnInfo!.totalBalance * currency.currentPrice,
          symbol: baseCurrency.symbol,
        )}';
    }
    if (transactionListItem.operationType == OperationType.cryptoBuy) {
      return '${intl.history_with} ${getIt<AppStore>().isBalanceHide ? '**** ${transactionListItem.cryptoBuyInfo?.paymentAssetId ?? ''}' : volumeFormat(
          decimal: transactionListItem.cryptoBuyInfo?.paymentAmount ?? Decimal.zero,
          symbol: transactionListItem.cryptoBuyInfo?.paymentAssetId ?? '',
        )}';
    }
    if (transactionListItem.operationType == OperationType.bankingBuy && source != TransactionItemSource.eurAccount) {
      return '${intl.history_with} ${getIt<AppStore>().isBalanceHide ? '**** ${transactionListItem.cryptoBuyInfo?.paymentAssetId ?? ''}' : volumeFormat(
          decimal: transactionListItem.cryptoBuyInfo?.paymentAmount ?? Decimal.zero,
          symbol: transactionListItem.cryptoBuyInfo?.paymentAssetId ?? '',
        )}';
    }
    if (transactionListItem.operationType == OperationType.bankingBuy && source == TransactionItemSource.eurAccount) {
      return '${intl.history_for} ${getIt<AppStore>().isBalanceHide ? '**** ${transactionListItem.cryptoBuyInfo?.buyAssetId ?? ''}' : volumeFormat(
          decimal: transactionListItem.cryptoBuyInfo?.buyAmount ?? Decimal.zero,
          symbol: transactionListItem.cryptoBuyInfo?.buyAssetId ?? '',
        )}';
    }
    if ((transactionListItem.operationType == OperationType.bankingSell ||
            transactionListItem.operationType == OperationType.cardBankingSell) &&
        source != TransactionItemSource.cryptoAccount) {
      return '${intl.history_with} ${getIt<AppStore>().isBalanceHide ? '**** ${transactionListItem.sellCryptoInfo?.sellAssetId ?? ''}' : volumeFormat(
          decimal: transactionListItem.sellCryptoInfo?.sellAmount ?? Decimal.zero,
          symbol: transactionListItem.sellCryptoInfo?.sellAssetId ?? '',
        )}';
    }
    if ((transactionListItem.operationType == OperationType.bankingSell ||
            transactionListItem.operationType == OperationType.cardBankingSell) &&
        source == TransactionItemSource.cryptoAccount) {
      return '${intl.history_for} ${getIt<AppStore>().isBalanceHide ? '**** ${transactionListItem.sellCryptoInfo?.buyAssetId ?? ''}' : volumeFormat(
          decimal: transactionListItem.sellCryptoInfo?.buyAmount ?? Decimal.zero,
          symbol: transactionListItem.sellCryptoInfo?.buyAssetId ?? '',
        )}';
    }
    if (transactionListItem.operationType == OperationType.sendGlobally) {
      return '${intl.history_for} ${getIt<AppStore>().isBalanceHide ? '**** ${transactionListItem.withdrawalInfo?.receiveAsset ?? ''}' : volumeFormat(
          decimal: transactionListItem.withdrawalInfo?.receiveAmount ?? Decimal.zero,
          symbol: transactionListItem.withdrawalInfo?.receiveAsset ?? '',
        )}';
    }

    return null;
  }
}

class TransactionBaseItem extends StatelessWidget {
  const TransactionBaseItem({
    required this.onTap,
    required this.icon,
    required this.labele,
    this.labelIcon,
    required this.balanceChange,
    required this.status,
    required this.timeStamp,
    this.rightSupplement,
    this.supplement,
  });

  final void Function() onTap;
  final Widget icon;
  final String labele;
  final Widget? labelIcon;
  final String balanceChange;
  final Status status;
  final String timeStamp;
  final String? rightSupplement;
  final String? supplement;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: colors.grey5,
      hoverColor: Colors.transparent,
      child: SPaddingH24(
        child: SizedBox(
          height: 80,
          child: Column(
            children: [
              const SpaceH12(),
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: icon,
                  ),
                  const SpaceW10(),
                  Expanded(
                    child: Row(
                      children: [
                        TransactionListItemHeaderText(
                          text: labele,
                          color: status == Status.declined ? colors.grey2 : colors.black,
                        ),
                        if (labelIcon != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 4, top: 1.5),
                            child: SizedBox(
                              height: 16,
                              child: labelIcon,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 220,
                      minWidth: 100,
                    ),
                    child: AutoSizeText(
                      balanceChange,
                      textAlign: TextAlign.end,
                      minFontSize: 4.0,
                      maxLines: 1,
                      strutStyle: const StrutStyle(
                        height: 1.56,
                        fontSize: 18.0,
                        fontFamily: 'Gilroy',
                      ),
                      style: TextStyle(
                        height: 1.56,
                        fontSize: 18.0,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        color: status == Status.declined ? colors.grey2 : colors.black,
                        decoration: status == Status.declined ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        const SpaceW34(),
                        Flexible(
                          child: TransactionListItemText(
                            text: supplement ?? '${formatDateToDMY(timeStamp)}, ${formatDateToHm(timeStamp)}',
                            color: colors.grey1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 120,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (rightSupplement != null)
                          TransactionListItemText(
                            text: rightSupplement!,
                            color: colors.grey1,
                          ),
                        const SpaceW5(),
                        if (status == Status.inProgress)
                          const SimpleLoader()
                        else if (status == Status.completed)
                          const SHistoryCompletedIcon()
                        else if (status == Status.declined)
                          SHistoryDeclinedIcon(
                            color: colors.grey2,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
