import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_with_hidden_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from_all.dart';
import 'package:jetwallet/features/reccurring/helper/recurring_buys_operation_name.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

import '../../../../../../../../helper/format_date_to_hm.dart';
import '../../../../../../../../helper/is_operation_support_copy.dart';
import '../../../../../../../../helper/operation_name.dart';

class CommonTransactionDetailsBlock extends StatelessObserverWidget {
  const CommonTransactionDetailsBlock({
    Key? key,
    required this.transactionListItem,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;
    final currency = currencyFromAll(
      sSignalRModules.currenciesList,
      transactionListItem.assetId,
    );

    return Column(
      children: [
        if (transactionListItem.operationType == OperationType.recurringBuy)
          SPaddingH24(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SIconButton(
                  onTap: () => Navigator.pop(context),
                  defaultIcon: const SBackIcon(),
                  pressedIcon: const SBackPressedIcon(),
                ),
                const SpaceW12(),
                Expanded(
                  child: Text(
                    _transactionHeader(transactionListItem, currency, context),
                    style: sTextH5Style,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
                const SpaceW12(),
                const _IconPlaceholder(),
              ],
            ),
          ),
        if (transactionListItem.operationType != OperationType.recurringBuy)
          Text(
            _transactionHeader(transactionListItem, currency, context),
            style: sTextH5Style,
          ),
        const SpaceH67(),
        SPaddingH24(
          child: AutoSizeText(
            '${operationAmount(transactionListItem)} ${currency.symbol}',
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
        if (transactionListItem.status == Status.completed)
          Text(
            convertToUsd(
              transactionListItem.assetPriceInUsd,
              operationAmount(transactionListItem),
              baseCurrency,
            ),
            style: sBodyText2Style.copyWith(
              color: colors.grey2,
            ),
          ),
        Text(
          '${formatDateToDMY(transactionListItem.timeStamp)} '
          '- ${formatDateToHm(transactionListItem.timeStamp)}',
          style: sBodyText2Style.copyWith(
            color: colors.grey2,
          ),
        ),
        if (isOperationSupportCopy(transactionListItem))
          const SpaceH8()
        else
          const SpaceH72(),
      ],
    );
  }

  String _transactionHeader(
    OperationHistoryItem transactionListItem,
    CurrencyModel currency,
    BuildContext context,
  ) {
    if (transactionListItem.operationType == OperationType.simplexBuy) {
      return '${operationName(OperationType.buy, context)} '
          '${currency.description} - '
          '${operationName(transactionListItem.operationType, context)}';
    } else if (transactionListItem.operationType ==
        OperationType.recurringBuy) {
      return '${recurringBuysOperationByString(
        transactionListItem.recurringBuyInfo!.scheduleType ?? '',
      )} ${operationName(transactionListItem.operationType, context)}';
    } else if (transactionListItem.operationType ==
            OperationType.earningDeposit ||
        transactionListItem.operationType == OperationType.earningWithdrawal) {
      if (transactionListItem.earnInfo?.totalBalance !=
              transactionListItem.balanceChange.abs() &&
          transactionListItem.operationType == OperationType.earningDeposit) {
        return operationName(
          transactionListItem.operationType,
          context,
          isToppedUp: true,
        );
      }

      return operationName(transactionListItem.operationType, context);
    } else {
      return operationName(transactionListItem.operationType, context);
    }
  }

  String convertToUsd(
    Decimal assetPriceInUsd,
    Decimal balance,
    BaseCurrencyModel baseCurrency,
  ) {
    final usd = assetPriceInUsd * balance;
    if (usd < Decimal.zero) {
      final plusValue = usd.toString().split('-').last;

      return '≈ ${baseCurrenciesFormat(
        text: Decimal.parse(plusValue).toStringAsFixed(2),
        symbol: baseCurrency.symbol,
        prefix: baseCurrency.prefix,
      )}';
    }

    return '≈ ${baseCurrenciesFormat(
      text: usd.toStringAsFixed(2),
      symbol: baseCurrency.symbol,
      prefix: baseCurrency.prefix,
    )}';
  }

  Decimal operationAmount(OperationHistoryItem transactionListItem) {
    if (transactionListItem.operationType == OperationType.withdraw) {
      return transactionListItem.withdrawalInfo!.withdrawalAmount;
    }

    return transactionListItem.balanceChange;
  }
}

class _IconPlaceholder extends StatelessWidget {
  const _IconPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 24.0,
      height: 24.0,
    );
  }
}
