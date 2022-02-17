import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../../shared/providers/device_size/media_query_pod.dart';
import '../../../../../../../helpers/currency_from.dart';
import '../../../../../../../helpers/formatting/formatting.dart';
import '../../../../../../../helpers/text_size.dart';
import '../../../../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../../../helper/format_date_to_hm.dart';
import '../../../../../helper/operation_name.dart';
import '../../../../../helper/show_transaction_details.dart';
import 'components/transaction_list_item_header_text.dart';
import 'components/transaction_list_item_text.dart';

const _horizontalPadding = 48;
const _iconSize = 20;
const _iconAndTextPadding = 10;
const _transactionAndVolumePadding = 10;

class TransactionListItem extends HookWidget {
  const TransactionListItem({
    Key? key,
    this.removeDivider = false,
    required this.transactionListItem,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final bool removeDivider;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final mediaQuery = useProvider(mediaQueryPod);
    final currencies = context.read(currenciesPod);
    final currency = currencyFrom(
      currencies,
      transactionListItem.assetId,
    );
    final transactionVolumeText = volumeFormat(
      prefix: currency.prefixSymbol,
      decimal: transactionListItem.balanceChange,
      accuracy: currency.accuracy,
      symbol: currency.symbol,
    );
    final transactionVolumeTextSize = textSize(
      transactionVolumeText,
      sSubtitle2Style,
    );
    final transactionNameWidth = mediaQuery.size.width -
        _horizontalPadding -
        _iconSize -
        _iconAndTextPadding -
        _transactionAndVolumePadding -
        transactionVolumeTextSize.width;

    return InkWell(
      onTap: () => showTransactionDetails(
        context,
        transactionListItem,
      ),
      child: SizedBox(
        height: 80,
        child: Column(
          children: [
            const SpaceH12(),
            Row(
              children: [
                _icon(transactionListItem.operationType),
                const SpaceW10(),
                TransactionListItemHeaderText(
                  text: operationName(transactionListItem.operationType),
                  width: transactionNameWidth,
                ),
                const Spacer(),
                TransactionListItemHeaderText(
                  text: transactionVolumeText,
                  width: transactionVolumeTextSize.width,
                ),
              ],
            ),
            Row(
              children: [
                const SpaceW30(),
                TransactionListItemText(
                  text: '${formatDateToDMY(transactionListItem.timeStamp)} '
                      '- ${formatDateToHm(transactionListItem.timeStamp)}',
                  color: colors.grey2,
                ),
                const Spacer(),
                if (transactionListItem.operationType ==
                    OperationType.sell) ...[
                  TransactionListItemText(
                    text: 'For ${volumeFormat(
                      prefix: currency.prefixSymbol,
                      decimal: transactionListItem.swapInfo!.buyAmount,
                      accuracy: currency.accuracy,
                      symbol: currency.symbol,
                    )}',
                    color: colors.grey2,
                  ),
                ],
                if (transactionListItem.operationType == OperationType.buy) ...[
                  TransactionListItemText(
                    text: 'With ${volumeFormat(
                      prefix: currency.prefixSymbol,
                      decimal: transactionListItem.swapInfo!.sellAmount,
                      accuracy: currency.accuracy,
                      symbol: currency.symbol,
                    )}',
                    color: colors.grey2,
                  ),
                ]
              ],
            ),
            const SpaceH18(),
            if (!removeDivider) const SDivider(),
          ],
        ),
      ),
    );
  }

  Widget _icon(OperationType type) {
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
      case OperationType.unknown:
        return const SizedBox();
    }
  }
}
