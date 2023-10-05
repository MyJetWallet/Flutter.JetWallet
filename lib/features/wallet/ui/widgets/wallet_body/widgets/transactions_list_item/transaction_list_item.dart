import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../helper/format_date_to_hm.dart';
import '../../../../../helper/nft_by_symbol.dart';
import '../../../../../helper/nft_types.dart';
import '../../../../../helper/show_transaction_details.dart';
import 'components/transaction_list_item_header_text.dart';
import 'components/transaction_list_item_text.dart';

class TransactionListItem extends StatelessObserverWidget {
  const TransactionListItem({
    super.key,
    required this.transactionListItem,
    this.onItemTapLisener,
  });

  final OperationHistoryItem transactionListItem;
  final void Function(String assetSymbol)? onItemTapLisener;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
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

    final nftAsset = getNftItem(
      transactionListItem,
      sSignalRModules.allNftList,
    );

    return InkWell(
      onTap: () {
        onItemTapLisener?.call(transactionListItem.assetId);
        showTransactionDetails(
          context,
          transactionListItem,
          null,
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
                    colors.grey2,
                  ),
                  if (transactionListItem.operationType == OperationType.buy ||
                      transactionListItem.operationType == OperationType.sell ||
                      transactionListItem.operationType == OperationType.swap)
                    const SpaceW6()
                  else
                    const SpaceW10(),
                  Expanded(
                    child: Row(
                      children: [
                        TransactionListItemHeaderText(
                          text: _transactionItemTitle(
                            transactionListItem,
                            context,
                          ),
                          color: colors.black,
                        ),
                        if (transactionListItem.operationType == OperationType.giftSend ||
                            transactionListItem.operationType == OperationType.giftReceive) ...[
                          Container(
                            height: 16,
                            margin: const EdgeInsets.only(top: 4),
                            child: const SGiftSendIcon(),
                          ),
                        ],
                        if (transactionListItem.operationType == OperationType.rewardPayment) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 4, top: 1.5),
                            child: SizedBox(
                              height: 16,
                              child: SvgPicture.asset(
                                simpleRewardTrophy,
                              ),
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
                      nftTypes.contains(transactionListItem.operationType)
                          ? nftAsset.name ?? 'NFT'
                          : volumeFormat(
                              decimal: (transactionListItem.operationType == OperationType.withdraw ||
                                      transactionListItem.operationType == OperationType.ibanSend ||
                                      transactionListItem.operationType == OperationType.sendGlobally ||
                                      transactionListItem.operationType == OperationType.transferByPhone ||
                                      transactionListItem.operationType == OperationType.giftSend)
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
                        color: transactionListItem.status == Status.declined ? colors.grey1 : colors.black,
                        decoration: transactionListItem.status == Status.declined ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const SpaceW30(),
                  TransactionListItemText(
                    text: '${formatDateToDMY(
                      transactionListItem.timeStamp,
                    )}'
                        ', ${formatDateToHm(transactionListItem.timeStamp)}',
                    color: colors.grey2,
                  ),
                  const Spacer(),
                  if (transactionListItem.operationType == OperationType.sell)
                    TransactionListItemText(
                      text: '${intl.transactionListItem_forText} '
                          '${volumeFormat(
                        decimal: transactionListItem.swapInfo!.buyAmount,
                        accuracy: currencyFrom(
                          currencies,
                          transactionListItem.swapInfo!.buyAssetId,
                        ).accuracy,
                        symbol: transactionListItem.swapInfo!.buyAssetId,
                      )}',
                      color: colors.grey2,
                    ),
                  if (transactionListItem.operationType == OperationType.buy) ...[
                    TransactionListItemText(
                      text: '${intl.withText} ${volumeFormat(
                        decimal: transactionListItem.swapInfo!.sellAmount,
                        accuracy: currencyFrom(
                          currencies,
                          transactionListItem.swapInfo!.sellAssetId,
                        ).accuracy,
                        symbol: transactionListItem.swapInfo!.sellAssetId,
                      )}',
                      color: colors.grey2,
                    ),
                    const SpaceW5(),
                  ],
                  if (transactionListItem.operationType == OperationType.simplexBuy)
                    TransactionListItemText(
                      text: '${intl.withText} '
                          '${volumeFormat(
                        decimal: transactionListItem.buyInfo!.sellAmount,
                        symbol: transactionListItem.buyInfo!.sellAssetId,
                        accuracy: paymentCurrency.accuracy,
                      )}',
                      color: colors.grey2,
                    ),
                  if (transactionListItem.operationType == OperationType.recurringBuy)
                    TransactionListItemText(
                      text: '${intl.withText} ${volumeFormat(
                        decimal: transactionListItem.recurringBuyInfo!.sellAmount,
                        accuracy: currency.accuracy,
                        symbol: transactionListItem.recurringBuyInfo!.sellAssetId!,
                      )}',
                      color: colors.grey2,
                    ),
                  if (transactionListItem.operationType == OperationType.earningDeposit &&
                      transactionListItem.earnInfo?.totalBalance == transactionListItem.balanceChange.abs())
                    TransactionListItemText(
                      text: ' ${volumeFormat(
                        decimal: transactionListItem.earnInfo!.totalBalance * currency.currentPrice,
                        accuracy: baseCurrency.accuracy,
                        symbol: baseCurrency.symbol,
                      )}',
                      color: colors.grey2,
                    ),
                  if (transactionListItem.status == Status.inProgress) const SimpleLoader(),
                  if (transactionListItem.status == Status.completed) const SHistoryCompletedIcon(),
                  if (transactionListItem.status == Status.declined)
                    SHistoryDeclinedIcon(
                      color: colors.grey2,
                    ),
                ],
              ),
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
      case OperationType.ibanDeposit:
        return SReceiveByPhoneIcon(color: isFailed ? color : null);
      case OperationType.p2pBuy:
        return SPlusIcon(color: isFailed ? color : null);
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
        return SReceiveByPhoneIcon(color: isFailed ? color : null);
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
      case OperationType.buyApplePay:
        return SPlusIcon(color: isFailed ? color : null);
      case OperationType.buyGooglePay:
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
      case OperationType.ibanSend:
        return SSendByPhoneIcon(color: isFailed ? color : null);
      case OperationType.sendGlobally:
        return SSendByPhoneIcon(color: isFailed ? color : null);
      case OperationType.giftSend:
        return SSendByPhoneIcon(color: isFailed ? color : null);
      case OperationType.giftReceive:
        return SReceiveByPhoneIcon(color: isFailed ? color : null);
      default:
        return SPlusIcon(color: isFailed ? color : null);
    }
  }
}
