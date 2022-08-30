import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class EarningDepositDetails extends StatelessObserverWidget {
  const EarningDepositDetails({
    Key? key,
    required this.transactionListItem,
    required this.onCopyAction,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final currencies = sCurrencies.currencies;

    final currentCurrency = currencyFrom(
      currencies,
      transactionListItem.assetId,
    );
    final baseCurrency = sSignalRModules.baseCurrency;

    return SPaddingH24(
      child: Column(
        children: [
          TransactionDetailsItem(
            text: intl.earn_transaction_id,
            value: Row(
              children: [
                TransactionDetailsValueText(
                  text: shortAddressForm(transactionListItem.operationId),
                ),
                const SpaceW10(),
                SIconButton(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: transactionListItem.operationId,
                      ),
                    );

                    onCopyAction('Transaction ID');
                  },
                  defaultIcon: const SCopyIcon(),
                  pressedIcon: const SCopyPressedIcon(),
                ),
              ],
            ),
          ),
          const SpaceH14(),
          TransactionDetailsItem(
            text: intl.earn_total_balance,
            value: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TransactionDetailsValueText(
                  text: volumeFormat(
                    decimal: transactionListItem.earnInfo != null &&
                            transactionListItem.earnInfo!.totalBalance !=
                                Decimal.zero &&
                            currentCurrency.currentPrice != Decimal.zero
                        ? Decimal.parse(
                            '${transactionListItem.earnInfo!.totalBalance.toDouble() / currentCurrency.currentPrice.toDouble()}',
                          )
                        : Decimal.zero,
                    accuracy: currentCurrency.accuracy,
                    symbol: currentCurrency.symbol,
                  ),
                ),
                Text(
                  volumeFormat(
                    prefix: baseCurrency.prefix,
                    decimal: transactionListItem.earnInfo?.totalBalance ??
                        Decimal.zero,
                    accuracy: baseCurrency.accuracy,
                    symbol: baseCurrency.symbol,
                  ),
                  style: sBodyText2Style.copyWith(
                    color: colors.grey1,
                  ),
                ),
              ],
            ),
          ),
          const SpaceH14(),
          TransactionDetailsItem(
            text: intl.earn_details_apy,
            value: TransactionDetailsValueText(
              text: '${transactionListItem.earnInfo?.apy}%',
            ),
          ),
          const SpaceH14(),
          TransactionDetailsItem(
            text: intl.earn_details_subscription,
            value: TransactionDetailsValueText(
              text: transactionListItem.earnInfo?.offerInfo?.title ?? '',
            ),
          ),
          const SpaceH40(),
        ],
      ),
    );
  }
}
