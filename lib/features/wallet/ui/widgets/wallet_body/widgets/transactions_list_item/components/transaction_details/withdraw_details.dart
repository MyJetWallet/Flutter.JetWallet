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
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class WithdrawDetails extends StatelessObserverWidget {
  const WithdrawDetails({
    Key? key,
    required this.transactionListItem,
    required this.onCopyAction,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      transactionListItem.assetId,
    );

    return SPaddingH24(
      child: Column(
        children: [
          TransactionDetailsItem(
            text: intl.withdrawDetails_amount,
            value: TransactionDetailsValueText(
              text: volumeFormat(
                prefix: currency.prefixSymbol,
                decimal: transactionListItem.withdrawalInfo!.withdrawalAmount,
                accuracy: currency.accuracy,
                symbol: currency.symbol,
              ),
            ),
          ),
          const SpaceH10(),
          TransactionDetailsItem(
            text: '${intl.transaction} ${intl.withdrawDetails_fee}',
            value: transactionListItem.withdrawalInfo!.isInternal
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TransactionDetailsValueText(
                        text: intl.noFee,
                      ),
                      Text(
                        intl.withdrawDetails_internalTransfer,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Builder(
                    builder: (context) {
                      final currency = currencyFrom(
                        sSignalRModules.currenciesList,
                        transactionListItem.withdrawalInfo!.feeAssetId ??
                            transactionListItem
                                .withdrawalInfo!.withdrawalAssetId,
                      );

                      return TransactionDetailsValueText(
                        text: volumeFormat(
                          prefix: currency.prefixSymbol,
                          decimal:
                              transactionListItem.withdrawalInfo!.feeAmount,
                          accuracy: currency.accuracy,
                          symbol: currency.symbol,
                        ),
                      );
                    },
                  ),
          ),
          const SpaceH10(),
          TransactionDetailsItem(
            text: '${intl.transaction} ID',
            value: Row(
              children: [
                TransactionDetailsValueText(
                  text:
                      shortAddressOperationId(transactionListItem.operationId),
                ),
                const SpaceW10(),
                SIconButton(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: transactionListItem.operationId,
                      ),
                    );

                    onCopyAction('${intl.transaction} ID');
                  },
                  defaultIcon: const SCopyIcon(),
                  pressedIcon: const SCopyPressedIcon(),
                ),
              ],
            ),
          ),
          const SpaceH10(),
          if (transactionListItem.withdrawalInfo!.toAddress != null) ...[
            TransactionDetailsItem(
              text: intl.withdrawDetails_withdrawalTo,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.withdrawalInfo!.toAddress != null
                        ? shortAddressForm(
                            transactionListItem.withdrawalInfo!.toAddress!,
                          )
                        : '',
                  ),
                  const SpaceW10(),
                  SIconButton(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: transactionListItem.withdrawalInfo!.toAddress ??
                              '',
                        ),
                      );

                      onCopyAction(intl.withdrawDetails_withdrawalTo);
                    },
                    defaultIcon: const SCopyIcon(),
                    pressedIcon: const SCopyPressedIcon(),
                  ),
                ],
              ),
            ),
            const SpaceH10(),
          ],
          TransactionDetailsStatus(
            status: transactionListItem.status,
          ),
          const SpaceH40(),
        ],
      ),
    );
  }
}
