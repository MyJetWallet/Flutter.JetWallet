import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/reccurring/helper/recurring_buys_operation_name.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

import '../../../../../../../../../../utils/helpers/check_local_operation.dart';
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
    final catchingTypes =
        transactionListItem.operationType == OperationType.nftBuy ||
            transactionListItem.operationType == OperationType.nftSwap ||
            transactionListItem.operationType == OperationType.nftSell;

    final isLocal = transactionListItem.operationType ==
        OperationType.cryptoInfo &&
        isOperationLocal(
          transactionListItem.cryptoBuyInfo?.paymentMethod ??
          PaymentMethodType.unsupported,
        );

    final currencyForOperation =
        transactionListItem.operationType == OperationType.nftBuy ||
                transactionListItem.operationType == OperationType.nftSwap
            ? transactionListItem.swapInfo?.sellAssetId ?? ''
            : transactionListItem.operationType == OperationType.nftSell
                ? transactionListItem.swapInfo?.buyAssetId ?? ''
                : transactionListItem.assetId;

    final currency = getIt<FormatService>().findCurrency(
      assetSymbol: currencyForOperation,
      findInHideTerminalList: true,
    );

    final nftAsset = getNftItem(
      transactionListItem,
      sSignalRModules.allNftList,
    );

    final devicePR = MediaQuery.of(context).devicePixelRatio;

    return Column(
      children: [
        if (transactionListItem.operationType != OperationType.sendGlobally)
          SPaddingH24(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
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
                SIconButton(
                  onTap: () => Navigator.pop(context),
                  defaultIcon: const SErasePressedIcon(),
                  pressedIcon: const SEraseMarketIcon(),
                ),
              ],
            ),
          ),
        if (transactionListItem.operationType == OperationType.sendGlobally)
          SPaddingH24(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _IconPlaceholder(),
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
                SIconButton(
                  onTap: () => Navigator.pop(context),
                  defaultIcon: const SEraseIcon(),
                  pressedIcon: const SErasePressedIcon(),
                ),
              ],
            ),
          ),
        if (devicePR == 2) ...[
          const SpaceH30(),
        ] else if (transactionListItem.operationType ==
            OperationType.sendGlobally || ((transactionListItem.operationType ==
            OperationType.p2pBuy || isLocal) && transactionListItem.status ==
            Status.inProgress)) ...[
          const SpaceH40(),
        ] else ...[
          const SpaceH67(),
        ],
        if ((transactionListItem.operationType == OperationType.p2pBuy ||
            isLocal) && transactionListItem.status == Status.inProgress)
          Text(
            intl.history_approximately,
            style: sBodyText2Style.copyWith(
              color: colors.grey2,
            ),
          ),
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
          if (transactionListItem.operationType == OperationType.ibanSend ||
              transactionListItem.status == Status.completed)
            Text(
              getIt<FormatService>().convertHistoryToBaseCurrency(
                transactionListItem,
                operationAmount(transactionListItem),
                getOperationAsset(transactionListItem),
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

  Decimal operationAmount(OperationHistoryItem transactionListItem) {
    if (transactionListItem.operationType == OperationType.withdraw ||
        transactionListItem.operationType == OperationType.ibanSend ||
        transactionListItem.operationType == OperationType.sendGlobally) {
      return Decimal.parse(
        '${transactionListItem.withdrawalInfo!.withdrawalAmount}'
            .replaceAll('-', ''),
      );
    }

    if (transactionListItem.operationType == OperationType.transferByPhone) {
      return Decimal.parse(
        '${transactionListItem.transferByPhoneInfo?.withdrawalAmount ?? Decimal.zero}'
            .replaceAll('-', ''),
      );
    }

    return Decimal.parse(
      '${transactionListItem.balanceChange}'.replaceAll('-', ''),
    );
  }

  String getOperationAsset(OperationHistoryItem transactionListItem) {
    if (transactionListItem.operationType == OperationType.withdraw ||
        transactionListItem.operationType == OperationType.ibanSend ||
        transactionListItem.operationType == OperationType.sendGlobally) {
      return transactionListItem.withdrawalInfo?.withdrawalAssetId ?? '';
    }

    if (transactionListItem.operationType == OperationType.transferByPhone) {
      return transactionListItem.transferByPhoneInfo?.withdrawalAssetId ?? '';
    }

    return transactionListItem.assetId;
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
