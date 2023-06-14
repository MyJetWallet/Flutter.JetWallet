import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/transaction_details_name_text.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/find_blockchain_by_descr.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class SendGloballyDetails extends StatelessObserverWidget {
  const SendGloballyDetails({
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
      transactionListItem.withdrawalInfo?.withdrawalAssetId ?? 'EUR',
    );

    final obj = sSignalRModules.globalSendMethods!.methods!.firstWhere(
      (element) => element.type == transactionListItem.paymeInfo?.methodType,
    );

    return SPaddingH24(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              intl.global_send_receiver_details,
              style: sTextH5Style,
            ),
          ),
          const SizedBox(height: 18),
          if (transactionListItem.paymeInfo?.accountNumber != null &&
              transactionListItem.paymeInfo!.accountNumber!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_account_number,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.accountNumber ?? '',
                  ),
                  const SpaceW10(),
                  SIconButton(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: transactionListItem.paymeInfo?.accountNumber ??
                              '',
                        ),
                      );

                      onCopyAction('');
                    },
                    defaultIcon: const SCopyIcon(),
                    pressedIcon: const SCopyPressedIcon(),
                  ),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.recipientName != null &&
              transactionListItem.paymeInfo!.recipientName!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_beneficiary_name,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.recipientName ?? '',
                  ),
                  const SpaceW10(),
                  SIconButton(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: transactionListItem.paymeInfo?.recipientName ??
                              '',
                        ),
                      );

                      onCopyAction('');
                    },
                    defaultIcon: const SCopyIcon(),
                    pressedIcon: const SCopyPressedIcon(),
                  ),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.bankName != null &&
              transactionListItem.paymeInfo!.bankName!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_bank_name,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.bankName ?? '',
                  ),
                  const SpaceW10(),
                  SIconButton(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: transactionListItem.paymeInfo?.bankName ?? '',
                        ),
                      );

                      onCopyAction('');
                    },
                    defaultIcon: const SCopyIcon(),
                    pressedIcon: const SCopyPressedIcon(),
                  ),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.ifscCode != null &&
              transactionListItem.paymeInfo!.ifscCode!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_ifsc_code,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.ifscCode ?? '',
                  ),
                  const SpaceW10(),
                  SIconButton(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: transactionListItem.paymeInfo?.ifscCode ?? '',
                        ),
                      );

                      onCopyAction('');
                    },
                    defaultIcon: const SCopyIcon(),
                    pressedIcon: const SCopyPressedIcon(),
                  ),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.cardNumber != null &&
              transactionListItem.paymeInfo!.cardNumber!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_card_number,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.cardNumber ?? '',
                  ),
                  const SpaceW10(),
                  SIconButton(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: transactionListItem.paymeInfo?.cardNumber ?? '',
                        ),
                      );

                      onCopyAction('');
                    },
                    defaultIcon: const SCopyIcon(),
                    pressedIcon: const SCopyPressedIcon(),
                  ),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.iban != null &&
              transactionListItem.paymeInfo!.iban!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_iban,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.iban ?? '',
                  ),
                  const SpaceW10(),
                  SIconButton(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: transactionListItem.paymeInfo?.iban ?? '',
                        ),
                      );

                      onCopyAction('');
                    },
                    defaultIcon: const SCopyIcon(),
                    pressedIcon: const SCopyPressedIcon(),
                  ),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.phoneNumber != null &&
              transactionListItem.paymeInfo!.phoneNumber!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_phone_number,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.phoneNumber ?? '',
                  ),
                  const SpaceW10(),
                  SIconButton(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text:
                              transactionListItem.paymeInfo?.phoneNumber ?? '',
                        ),
                      );

                      onCopyAction('');
                    },
                    defaultIcon: const SCopyIcon(),
                    pressedIcon: const SCopyPressedIcon(),
                  ),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.panNumber != null &&
              transactionListItem.paymeInfo!.panNumber!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_pan_number,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.panNumber ?? '',
                  ),
                  const SpaceW10(),
                  SIconButton(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: transactionListItem.paymeInfo?.panNumber ?? '',
                        ),
                      );

                      onCopyAction('');
                    },
                    defaultIcon: const SCopyIcon(),
                    pressedIcon: const SCopyPressedIcon(),
                  ),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.upiAddress != null &&
              transactionListItem.paymeInfo!.upiAddress!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_upi_address,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.upiAddress ?? '',
                  ),
                  const SpaceW10(),
                  SIconButton(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: transactionListItem.paymeInfo?.upiAddress ?? '',
                        ),
                      );

                      onCopyAction('');
                    },
                    defaultIcon: const SCopyIcon(),
                    pressedIcon: const SCopyPressedIcon(),
                  ),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (transactionListItem.paymeInfo?.bankAccount != null &&
              transactionListItem.paymeInfo!.bankAccount!.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.global_send_history_bank_account,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: transactionListItem.paymeInfo?.bankAccount ?? '',
                  ),
                  const SpaceW10(),
                  SIconButton(
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                        text: transactionListItem.paymeInfo?.bankAccount ?? '',
                      ));

                      onCopyAction('');
                    },
                    defaultIcon: const SCopyIcon(),
                    pressedIcon: const SCopyPressedIcon(),
                  ),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              intl.global_send_payment_details,
              style: sTextH5Style,
            ),
          ),
          const SizedBox(height: 18),
          TransactionDetailsItem(
            text: intl.send_globally_date,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.global_send_payment_method_title,
            value: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6,
              ),
              child: TransactionDetailsValueText(
                textAlign: TextAlign.end,
                text: obj.name ?? '',
              ),
            ),
          ),
          if (transactionListItem.status == Status.completed) ...[
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.send_globally_con_rate,
              value: TransactionDetailsValueText(
                text:
                    '${currency.prefixSymbol}1 = ${transactionListItem.withdrawalInfo!.receiveRate} ${transactionListItem.withdrawalInfo!.receiveAsset}',
              ),
            ),
          ],
          if (transactionListItem.status == Status.completed) ...[
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.send_globally_amount_in_uah,
              value: TransactionDetailsValueText(
                text: volumeFormat(
                  decimal: transactionListItem.withdrawalInfo!.receiveAmount ??
                      Decimal.zero,
                  accuracy: currency.accuracy,
                  symbol:
                      transactionListItem.withdrawalInfo?.receiveAsset ?? '',
                ),
              ),
            ),
          ],
          if (transactionListItem.status != Status.declined) ...[
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.send_globally_processing_fee,
              value: TransactionDetailsValueText(
                text: volumeFormat(
                  prefix: currency.prefixSymbol,
                  decimal: transactionListItem.withdrawalInfo!.feeAmount,
                  accuracy: currency.accuracy,
                  symbol: currency.symbol,
                ),
              ),
            ),
          ],
          const SpaceH18(),
          TransactionDetailsStatus(
            status: transactionListItem.status,
          ),
          const SpaceH40(),
        ],
      ),
    );
  }
}
