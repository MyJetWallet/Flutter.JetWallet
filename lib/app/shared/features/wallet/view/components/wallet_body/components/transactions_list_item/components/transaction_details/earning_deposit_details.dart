import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../../../../helpers/formatting/base/volume_format.dart';
import '../../../../../../../../../helpers/short_address_form.dart';
import '../../../../../../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../../../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../../../../../../market_details/helper/currency_from.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class EarningDepositDetails extends HookWidget {
  const EarningDepositDetails({
    Key? key,
    required this.transactionListItem,
    required this.onCopyAction,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.read(sColorPod);
    final currencies = context.read(currenciesPod);
    final intl = useProvider(intlPod);
    final currentCurrency = currencyFrom(
      currencies,
      transactionListItem.assetId,
    );
    final baseCurrency = useProvider(baseCurrencyPod);

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
                    decimal: transactionListItem.earnInfo?.totalBalance
                        ?? Decimal.zero,
                    accuracy: currentCurrency.accuracy,
                    symbol: currentCurrency.symbol,
                  ),
                ),
                Text(
                  volumeFormat(
                    prefix: baseCurrency.prefix,
                    decimal: transactionListItem.earnInfo != null
                        ? (transactionListItem.earnInfo!.totalBalance *
                        currentCurrency.currentPrice)
                        : Decimal.zero,
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
        ],
      ),
    );
  }
}
