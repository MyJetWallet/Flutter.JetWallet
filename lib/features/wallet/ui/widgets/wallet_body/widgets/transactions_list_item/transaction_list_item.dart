import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/reccurring/helper/recurring_buys_operation_name.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../helper/format_date_to_hm.dart';
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
    final baseCurrency = sSignalRModules.baseCurrency;

    return InkWell(
      onTap: () => showTransactionDetails(
        context,
        transactionListItem,
      ),
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
                  _iconFrom(transactionListItem.operationType),
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
                      volumeFormat(
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
                  if (transactionListItem.operationType == OperationType.sell)
                    TransactionListItemText(
                      text: '${intl.transactionListItem_forText} '
                          '${volumeFormat(
                        prefix: currency.prefixSymbol,
                        decimal: transactionListItem.swapInfo!.buyAmount,
                        accuracy: currency.accuracy,
                        symbol: transactionListItem.swapInfo!.buyAssetId,
                      )}',
                      color: colors.grey2,
                    ),
                  if (transactionListItem.operationType == OperationType.buy)
                    TransactionListItemText(
                      text: '${intl.withText} ${volumeFormat(
                        prefix: currency.prefixSymbol,
                        decimal: transactionListItem.swapInfo!.sellAmount,
                        accuracy: currency.accuracy,
                        symbol: transactionListItem.swapInfo!.sellAssetId,
                      )}',
                      color: colors.grey2,
                    ),
                  if (transactionListItem.operationType ==
                      OperationType.simplexBuy)
                    TransactionListItemText(
                      text: '${intl.withText} '
                          '\$${transactionListItem.buyInfo!.sellAmount}',
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
    if (transactionListItem.operationType == OperationType.simplexBuy) {
      return '${operationName(
        OperationType.buy,
        context,
      )}'
          ' ${transactionListItem.assetId} - '
          '${operationName(
        transactionListItem.operationType,
        context,
      )}';
    } else if (transactionListItem.operationType ==
        OperationType.recurringBuy) {
      return '${recurringBuysOperationByString(
        transactionListItem.recurringBuyInfo!.scheduleType ?? '',
      )} '
          '${operationName(
        transactionListItem.operationType,
        context,
      )}';
    } else if (transactionListItem.operationType ==
        OperationType.earningDeposit) {
      return transactionListItem.earnInfo?.totalBalance ==
              transactionListItem.balanceChange.abs()
          ? operationName(transactionListItem.operationType, context)
          : operationName(
              transactionListItem.operationType,
              context,
              isToppedUp: true,
            );
    } else {
      return operationName(
        transactionListItem.operationType,
        context,
      );
    }
  }

  Widget _iconFrom(OperationType type) {
    switch (type) {
      case OperationType.deposit:
        return const SDepositIcon();
      case OperationType.withdraw:
        return const SWithdrawalFeeIcon();
      case OperationType.transferByPhone:
        return const SSendByPhoneIcon();
      case OperationType.receiveByPhone:
        return const SReceiveByPhoneIcon();
      case OperationType.buy:
        return const SPlusIcon();
      case OperationType.sell:
        return const SMinusIcon();
      case OperationType.paidInterestRate:
        return const SPaidInterestRateIcon();
      case OperationType.feeSharePayment:
        return const SPaidInterestRateIcon();
      case OperationType.withdrawalFee:
        return const SWithdrawalFeeIcon();
      case OperationType.swap:
        return const SSwapIcon();
      case OperationType.rewardPayment:
        return const SRewardPaymentIcon();
      case OperationType.simplexBuy:
        return const SDepositIcon();
      case OperationType.recurringBuy:
        return const SPlusIcon();
      case OperationType.earningWithdrawal:
        return const SPaidInterestRateIcon();
      case OperationType.earningDeposit:
        return const SEarnDepositIcon();
      case OperationType.unknown:
        return const SizedBox();
      case OperationType.cryptoInfo:
        return const SDepositIcon();
    }
  }
}
