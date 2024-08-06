import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../../../core/di/di.dart';
import '../../../../../../../../app/store/app_store.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class BuyP2PDetails extends StatelessObserverWidget {
  const BuyP2PDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final paymentAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.cryptoBuyInfo?.paymentAssetId ?? 'EUR'),
        )
        .first;

    final buyAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.cryptoBuyInfo?.buyAssetId ?? 'EUR'),
        )
        .first;

    return SPaddingH24(
      child: Column(
        children: [
          _BuyDetailsHeader(
            transactionListItem: transactionListItem,
          ),
          TransactionDetailsItem(
            text: intl.send_globally_date,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.iban_send_history_transaction_id,
            value: Row(
              children: [
                TransactionDetailsValueText(
                  text: shortTxhashFrom(transactionListItem.operationId),
                ),
                const SpaceW10(),
                HistoryCopyIcon(transactionListItem.operationId),
              ],
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.buy_confirmation_price,
            value: TransactionDetailsValueText(
              text: rateFor(buyAsset, paymentAsset),
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.history_paid_with,
            value: Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SpaceW8(),
                  SNetworkCachedSvg(
                    url: iconForPaymentMethod(
                      methodId: transactionListItem.cryptoBuyInfo?.paymentMethod ?? '',
                    ),
                    width: 24,
                    height: 24,
                    placeholder: const SizedBox(),
                  ),
                  const SpaceW8(),
                  Flexible(
                    child: TransactionDetailsValueText(
                      text: transactionListItem.cryptoBuyInfo?.paymentMethodName ?? '',
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SpaceH18(),
          Builder(
            builder: (context) {
              final currency = currencyFrom(
                sSignalRModules.currenciesWithHiddenList,
                transactionListItem.cryptoBuyInfo?.depositFeeAsset ??
                    transactionListItem.cryptoBuyInfo?.paymentAssetId ??
                    '',
              );

              return PaymentFeeRowWidget(
                fee: currency.type == AssetType.crypto
                    ? (transactionListItem.cryptoBuyInfo?.depositFeeAmount ?? Decimal.zero).toFormatCount(
                        accuracy: currency.accuracy,
                        symbol: currency.symbol,
                      )
                    : (transactionListItem.cryptoBuyInfo?.depositFeeAmount ?? Decimal.zero).toFormatSum(
                        accuracy: currency.accuracy,
                        symbol: currency.symbol,
                      ),
              );
            },
          ),
          const SpaceH18(),
          Builder(
            builder: (context) {
              final currency = currencyFrom(
                sSignalRModules.currenciesWithHiddenList,
                transactionListItem.cryptoBuyInfo?.tradeFeeAsset ??
                    transactionListItem.cryptoBuyInfo?.paymentAssetId ??
                    '',
              );

              return ProcessingFeeRowWidget(
                fee: currency.type == AssetType.crypto
                    ? (transactionListItem.cryptoBuyInfo?.tradeFeeAmount ?? Decimal.zero).toFormatCount(
                        accuracy: currency.accuracy,
                        symbol: currency.symbol,
                      )
                    : (transactionListItem.cryptoBuyInfo?.tradeFeeAmount ?? Decimal.zero).toFormatSum(
                        accuracy: currency.accuracy,
                        symbol: currency.symbol,
                      ),
              );
            },
          ),
          if (transactionListItem.status == Status.inProgress) ...[
            const SpaceH30(),
            SIconTextButton(
              text: intl.p2p_buy_payment_management,
              icon: Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.symmetric(
                  vertical: 6,
                ),
                child: Assets.svg.medium.settings.simpleSvg(
                  color: colors.blue,
                ),
              ),
              onTap: () async {
                sAnalytics.ptpBuyWebViewScreenView(
                  asset: buyAsset.symbol,
                  ptpCurrency: transactionListItem.cryptoBuyInfo?.paymentAssetId ?? '',
                  ptpBuyMethod: transactionListItem.cryptoBuyInfo?.paymentMethodName ?? '',
                );
                await launchURL(
                  context,
                  transactionListItem.cryptoBuyInfo?.paymentUrl ?? '',
                );
              },
              mainAxisSize: MainAxisSize.max,
            ),
          ],
          const SpaceH58(),
        ],
      ),
    );
  }

  String rateFor(
    CurrencyModel currency1,
    CurrencyModel currency2,
  ) {
    final base = transactionListItem.cryptoBuyInfo!.baseRate.toFormatCount(
      symbol: currency1.symbol,
    );

    final quote = transactionListItem.cryptoBuyInfo!.quoteRate.toFormatPrice(
      prefix: currency2.prefixSymbol,
      accuracy: currency2.accuracy,
    );

    return '$base = $quote';
  }
}

class _BuyDetailsHeader extends StatelessWidget {
  const _BuyDetailsHeader({
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final paymentAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.cryptoBuyInfo?.paymentAssetId ?? 'EUR'),
        )
        .first;

    final buyAsset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    )
        .where(
          (element) => element.symbol == (transactionListItem.cryptoBuyInfo?.buyAssetId ?? 'EUR'),
        )
        .first;

    return Column(
      children: [
        WhatToWhatConvertWidget(
          removeDefaultPaddings: true,
          isLoading: false,
          fromAssetIconUrl: paymentAsset.iconUrl,
          fromAssetDescription: '${paymentAsset.description} (${paymentAsset.symbol})',
          fromAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${paymentAsset.symbol}'
              : (transactionListItem.cryptoBuyInfo?.paymentAmount ?? Decimal.zero).toFormatCount(
                  symbol: paymentAsset.symbol,
                  accuracy: paymentAsset.accuracy,
                ),
          toAssetIconUrl: buyAsset.iconUrl,
          toAssetDescription: buyAsset.description,
          toAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${buyAsset.symbol}'
              : (transactionListItem.cryptoBuyInfo?.buyAmount ?? Decimal.zero).toFormatCount(
                  symbol: buyAsset.symbol,
                  accuracy: buyAsset.accuracy,
                ),
          isError: transactionListItem.status == Status.declined,
          isSmallerVersion: true,
        ),
        const SizedBox(height: 24),
        SBadge(
          status: transactionListItem.status == Status.inProgress
              ? SBadgeStatus.primary
              : transactionListItem.status == Status.completed
                  ? SBadgeStatus.success
                  : SBadgeStatus.error,
          text: transactionDetailsStatusText(transactionListItem.status),
          isLoading: transactionListItem.status == Status.inProgress,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
