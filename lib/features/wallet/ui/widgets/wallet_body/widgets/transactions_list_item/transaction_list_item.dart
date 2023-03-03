import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/reccurring/helper/recurring_buys_operation_name.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/nft_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../helper/format_date_to_hm.dart';
import '../../../../../helper/nft_by_symbol.dart';
import '../../../../../helper/nft_types.dart';
import '../../../../../helper/operation_name.dart';
import '../../../../../helper/show_transaction_details.dart';
import 'components/transaction_list_item_header_text.dart';
import 'components/transaction_list_item_text.dart';

class TransactionListItem extends StatelessObserverWidget {
  const TransactionListItem({
    Key? key,
    this.removeDivider = false,
    required this.transactionListItem,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final bool removeDivider;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final currencies = sSignalRModules.currenciesList;
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

    final nftAsset = getNftItem(
      transactionListItem,
      sSignalRModules.allNftList,
    );

    return InkWell(
      onTap: () {
        showTransactionDetails(
          context,
          transactionListItem,
        );
      },
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
                  _iconFrom(
                    transactionListItem.operationType,
                    transactionListItem.status == Status.declined,
                    colors.red,
                  ),
                  const SpaceW10(),
                  Expanded(
                    child: TransactionListItemHeaderText(
                      text: _transactionItemTitle(
                        transactionListItem,
                        context,
                      ),
                      color: transactionListItem.status == Status.declined
                          ? colors.red
                          : colors.black,
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 220,
                      minWidth: 100,
                    ),
                    child: AutoSizeText(
                      nftTypes.contains(transactionListItem.operationType)
                          ? nftAsset.name ?? 'NFT'
                          : volumeFormat(
                              prefix: currency.prefixSymbol,
                              decimal: transactionListItem.operationType ==
                                      OperationType.withdraw
                                  ? transactionListItem.balanceChange.abs()
                                  : transactionListItem.balanceChange,
                              accuracy: currency.accuracy,
                              symbol: currency.symbol,
                            ),
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
                        color: colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const SpaceW30(),
                  if (transactionListItem.status != Status.inProgress)
                    TransactionListItemText(
                      text: '${formatDateToDMY(
                          transactionListItem.timeStamp,
                        )} '
                          '- ${formatDateToHm(transactionListItem.timeStamp)}',
                      color: colors.grey2,
                    ),
                  if (transactionListItem.status == Status.inProgress)
                    TransactionListItemText(
                      text: '${intl.transactionListItem_balanceInProcess}...',
                      color: colors.grey2,
                    ),
                  const Spacer(),
                  if (transactionListItem.operationType ==
                          OperationType.nftSellOpposite ||
                      transactionListItem.operationType ==
                          OperationType.nftBuyOpposite ||
                      transactionListItem.operationType ==
                          OperationType.nftWithdrawalFee)
                    TransactionListItemText(
                      text: '${intl.transactionListItem_forText} '
                          '${nftAsset.name}',
                      color: colors.grey2,
                    ),
                  if (transactionListItem.operationType == OperationType.sell)
                    TransactionListItemText(
                      text: '${intl.transactionListItem_forText} '
                          '${volumeFormat(
                        prefix: currency.prefixSymbol,
                        decimal: transactionListItem.swapInfo!.buyAmount,
                        accuracy: currencyFrom(
                          currencies,
                          transactionListItem.swapInfo!.buyAssetId,
                        ).accuracy,
                        symbol: transactionListItem.swapInfo!.buyAssetId,
                      )}',
                      color: colors.grey2,
                    ),
                  if (transactionListItem.operationType == OperationType.buy)
                    TransactionListItemText(
                      text: '${intl.withText} ${volumeFormat(
                        prefix: currency.prefixSymbol,
                        decimal: transactionListItem.swapInfo!.sellAmount,
                        accuracy: currencyFrom(
                          currencies,
                          transactionListItem.swapInfo!.sellAssetId,
                        ).accuracy,
                        symbol: transactionListItem.swapInfo!.sellAssetId,
                      )}',
                      color: colors.grey2,
                    ),
                  if (transactionListItem.operationType ==
                      OperationType.simplexBuy)
                    TransactionListItemText(
                      text: '${intl.withText} '
                          '${volumeFormat(
                        decimal: transactionListItem.buyInfo!.sellAmount,
                        symbol: transactionListItem.buyInfo!.sellAssetId,
                        prefix: paymentCurrency.prefixSymbol,
                        accuracy: paymentCurrency.accuracy,
                      )}',
                      color: colors.grey2,
                    ),
                  if (transactionListItem.operationType ==
                      OperationType.recurringBuy)
                    TransactionListItemText(
                      text: '${intl.withText} ${volumeFormat(
                        prefix: currency.prefixSymbol,
                        decimal:
                            transactionListItem.recurringBuyInfo!.sellAmount,
                        accuracy: currency.accuracy,
                        symbol:
                            transactionListItem.recurringBuyInfo!.sellAssetId!,
                      )}',
                      color: colors.grey2,
                    ),
                  if (transactionListItem.operationType ==
                          OperationType.earningDeposit &&
                      transactionListItem.earnInfo?.totalBalance ==
                          transactionListItem.balanceChange.abs())
                    TransactionListItemText(
                      text: '${intl.earn_with} ${volumeFormat(
                        prefix: baseCurrency.prefix,
                        decimal: transactionListItem.earnInfo!.totalBalance *
                            currency.currentPrice,
                        accuracy: baseCurrency.accuracy,
                        symbol: baseCurrency.symbol,
                      )}',
                      color: colors.grey2,
                    ),
                ],
              ),
              const SpaceH18(),
              if (!removeDivider) const SDivider(),
            ],
          ),
        ),
      ),
    );
  }

  String _transactionItemTitle(
    OperationHistoryItem transactionListItem,
    BuildContext context,
  ) {
    return transactionListItem.operationType == OperationType.buy ||
        transactionListItem.operationType == OperationType.sell
        ? '${transactionListItem.swapInfo?.sellAssetId} '
        '${intl.operationName_exchangeTo} '
        '${transactionListItem.swapInfo?.buyAssetId}'
        : transactionListItem.assetId;
  }

  Widget _iconFrom(OperationType type, bool isFailed, Color color) {
    switch (type) {
      case OperationType.deposit:
        return SReceiveByPhoneIcon(color: isFailed ? color : null);
      case OperationType.withdraw:
        return SSendByPhoneIcon(color: isFailed ? color : null);
      case OperationType.transferByPhone:
        return SSendByPhoneIcon(color: isFailed ? color : null);
      case OperationType.receiveByPhone:
        return SReceiveByPhoneIcon(color: isFailed ? color : null);
      case OperationType.buy:
        return const SActionConvertIcon();
      case OperationType.sell:
        return const SActionConvertIcon();
      case OperationType.paidInterestRate:
        return SPlusIcon(color: isFailed ? color : null);
      case OperationType.feeSharePayment:
        return SPlusIcon(color: isFailed ? color : null);
      case OperationType.withdrawalFee:
        return SMinusIcon(color: isFailed ? color : null);
      case OperationType.swap:
        return const SActionConvertIcon();
      case OperationType.rewardPayment:
        return SPlusIcon(color: isFailed ? color : null);
      case OperationType.simplexBuy:
        return SPlusIcon(color: isFailed ? color : null);
      case OperationType.recurringBuy:
        return SPlusIcon(color: isFailed ? color : null);
      case OperationType.earningWithdrawal:
        return SPlusIcon(color: isFailed ? color : null);
      case OperationType.earningDeposit:
        return SMinusIcon(color: isFailed ? color : null);
      case OperationType.unknown:
        return const SizedBox();
      case OperationType.cryptoInfo:
        return SPlusIcon(color: isFailed ? color : null);
      case OperationType.nftBuy:
        return SPlusIcon(color: isFailed ? color : null);
      case OperationType.nftSwap:
        return SPlusIcon(color: isFailed ? color : null);
      case OperationType.nftSell:
        return SMinusIcon(color: isFailed ? color : null);
      case OperationType.nftSellOpposite:
        return SPlusIcon(color: isFailed ? color : null);
      case OperationType.nftBuyOpposite:
        return SMinusIcon(color: isFailed ? color : null);
      case OperationType.nftDeposit:
        return SReceiveByPhoneIcon(color: isFailed ? color : null);
      case OperationType.nftWithdrawal:
        return SSendByPhoneIcon(color: isFailed ? color : null);
      case OperationType.nftWithdrawalFee:
        return SMinusIcon(color: isFailed ? color : null);
      default:
        return SPlusIcon(color: isFailed ? color : null);
    }
  }
}
