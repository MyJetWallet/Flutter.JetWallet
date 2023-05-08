import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from_all.dart';
import 'package:jetwallet/features/reccurring/helper/recurring_buys_operation_name.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

import '../../../../../../../../../../core/services/remote_config/remote_config_values.dart';
import '../../../../../../../../helper/format_date_to_hm.dart';
import '../../../../../../../../helper/is_operation_support_copy.dart';
import '../../../../../../../../helper/nft_by_symbol.dart';
import '../../../../../../../../helper/nft_types.dart';
import '../../../../../../../../helper/operation_name.dart';

class CommonTransactionDetailsBlock extends StatelessObserverWidget {
  const CommonTransactionDetailsBlock({
    super.key,
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;
    final catchingTypes =
        transactionListItem.operationType == OperationType.nftBuy ||
            transactionListItem.operationType == OperationType.nftSwap ||
            transactionListItem.operationType == OperationType.nftSell;

    final currencyForOperation =
        transactionListItem.operationType == OperationType.nftBuy ||
                transactionListItem.operationType == OperationType.nftSwap
            ? transactionListItem.swapInfo?.sellAssetId ?? ''
            : transactionListItem.operationType == OperationType.nftSell
                ? transactionListItem.swapInfo?.buyAssetId ?? ''
                : transactionListItem.assetId;
    final currency = currencyFromAll(
      sSignalRModules.currenciesWithHiddenList,
      currencyForOperation,
    );

    final nftAsset = getNftItem(
      transactionListItem,
      sSignalRModules.allNftList,
    );

    final devicePR = MediaQuery.of(context).devicePixelRatio;

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
                    _transactionHeader(
                      transactionListItem,
                      currency,
                      context,
                      nftAsset.name,
                      intl,
                    ),
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
            _transactionHeader(
              transactionListItem,
              currency,
              context,
              nftAsset.name,
              intl,
            ),
            style: sTextH5Style,
          ),
        if (nftTypes.contains(transactionListItem.operationType))
          const SpaceH25()
        else
          devicePR == 2 ? const SpaceH30() : const SpaceH67(),
        if (nftTypes.contains(transactionListItem.operationType)) ...[
          Stack(
            children: [
              Positioned(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: const SSkeletonTextLoader(
                    height: 160,
                    width: 160,
                  ),
                ),
              ),
            ],
          ),
          if (catchingTypes) ...[
            const SpaceH22(),
          ] else ...[
            const SpaceH35(),
          ],
        ],
        if (!nftTypes.contains(transactionListItem.operationType) ||
            catchingTypes) ...[
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
          if ((transactionListItem.operationType == OperationType.ibanSend ||
                  transactionListItem.status == Status.completed) &&
              transactionListItem.operationType != OperationType.sendGlobally)
            Text(
              convertToUsd(
                basePrice(
                  catchingTypes
                      ? currency.currentPrice
                      : transactionListItem.assetPriceInUsd,
                  baseCurrency,
                  sSignalRModules.currenciesWithHiddenList,
                  transactionInCurrent: catchingTypes,
                  asset: transactionListItem.operationType ==
                          OperationType.ibanSend
                      ? transactionListItem.withdrawalInfo?.withdrawalAssetId
                      : null,
                ),
                operationAmount(transactionListItem),
                baseCurrency,
              ),
              style: sBodyText2Style.copyWith(
                color: colors.grey2,
              ),
            ),
        ],
        if (isOperationSupportCopy(transactionListItem))
          //const SpaceH8()
          const SizedBox.shrink()
        else
          const SpaceH72(),
      ],
    );
  }

  String _transactionHeader(
    OperationHistoryItem transactionListItem,
    CurrencyModel currency,
    BuildContext context,
    String? nftName,
    AppLocalizations intl,
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
    } else if (transactionListItem.operationType == OperationType.nftBuy ||
        transactionListItem.operationType == OperationType.nftSwap ||
        transactionListItem.operationType == OperationType.nftBuyOpposite) {
      return '${operationName(OperationType.buy, context)} $nftName';
    } else if (transactionListItem.operationType == OperationType.nftSell ||
        transactionListItem.operationType == OperationType.nftSellOpposite) {
      return '${operationName(OperationType.sell, context)} $nftName';
    } else if (transactionListItem.operationType ==
        OperationType.nftWithdrawal) {
      return '${intl.operationName_send} $nftName';
    } else if (transactionListItem.operationType ==
        OperationType.nftWithdrawalFee) {
      return '${intl.operationName_send} $nftName';
    } else if (transactionListItem.operationType == OperationType.nftDeposit) {
      return '${intl.operationName_receive} $nftName';
    } else if (transactionListItem.operationType == OperationType.buy ||
        transactionListItem.operationType == OperationType.sell) {
      return '${operationName(
        OperationType.swap,
        context,
      )}'
          ' ${transactionListItem.swapInfo?.sellAssetId} '
          '${intl.operationName_exchangeTo} '
          '${transactionListItem.swapInfo?.buyAssetId}';
    } else if (transactionListItem.operationType ==
        OperationType.sendGlobally) {
      return '${operationName(
        OperationType.sendGlobally,
        context,
      )}'
          ' ${transactionListItem.assetId} ';
    } else if (transactionListItem.operationType == OperationType.ibanSend) {
      return '${operationName(
        OperationType.ibanSend,
        context,
      )}'
          ' ${transactionListItem.assetId} ';
    } else {
      return operationName(
        transactionListItem.operationType,
        context,
        asset: transactionListItem.assetId,
      );
    }
  }

  String convertToUsd(
    Decimal assetPriceInUsd,
    Decimal balance,
    BaseCurrencyModel baseCurrency,
  ) {
    if (assetPriceInUsd == Decimal.zero) {
      return '≈ ${baseCurrenciesFormat(
        text: balance.toStringAsFixed(2),
        symbol: baseCurrency.symbol,
        prefix: baseCurrency.prefix,
      )}';
    }

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

  Decimal basePrice(
    Decimal assetPriceInUsd,
    BaseCurrencyModel baseCurrency,
    List<CurrencyModel> allCurrencies, {
    bool transactionInCurrent = false,
    String? asset,
  }) {
    final baseCurrencyMain = currencyFromAll(
      allCurrencies,
      baseCurrency.symbol,
    );

    final usdCurrency = currencyFromAll(
      allCurrencies,
      'USD',
    );

    if (asset != null) {
      if (baseCurrency.symbol == asset) {
        return Decimal.zero;
      }
    }

    if (baseCurrency.symbol == 'USD' || transactionInCurrent) {
      return assetPriceInUsd;
    }

    if (baseCurrencyMain.currentPrice == Decimal.zero) {
      return assetPriceInUsd * usdCurrency.currentPrice;
    }

    return Decimal.parse(
      '${double.parse('$assetPriceInUsd') / double.parse('${baseCurrencyMain.currentPrice}')}',
    );
  }

  Decimal operationAmount(OperationHistoryItem transactionListItem) {
    if (transactionListItem.operationType == OperationType.withdraw ||
        transactionListItem.operationType == OperationType.ibanSend ||
        transactionListItem.operationType == OperationType.sendGlobally ||
        transactionListItem.operationType == OperationType.transferByPhone) {
      return transactionListItem.withdrawalInfo!.withdrawalAmount;
    }

    if (transactionListItem.operationType == OperationType.nftBuy ||
        transactionListItem.operationType == OperationType.nftSwap) {
      return transactionListItem.swapInfo!.sellAmount;
    }

    if (transactionListItem.operationType == OperationType.nftSell) {
      return transactionListItem.swapInfo!.buyAmount;
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
