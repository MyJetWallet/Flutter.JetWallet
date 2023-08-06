import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/send_gift/widgets/share_gift_result_bottom_sheet.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_kit/modules/shared/stack_loader/stack_loader.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../../../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../../../../../../utils/helpers/currency_from.dart';
import '../../../../../../../helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_status.dart';
import 'components/transaction_details_value_text.dart';

class GiftSendDetails extends StatelessObserverWidget {
  const GiftSendDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    final receiverContact = transactionListItem.giftSendInfo?.toEmail ??
        transactionListItem.giftSendInfo?.toPhoneNumber ??
        '';
    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      transactionListItem.assetId,
    );

    final store = StackLoaderStore();

    return StackLoader(
      loaderText: intl.register_pleaseWait,
      loading: store,
      child: SPaddingH24(
        child: Column(
          children: [
            TransactionDetailsItem(
              text: intl.date,
              value: TransactionDetailsValueText(
                text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                    ', ${formatDateToHm(transactionListItem.timeStamp)}',
              ),
            ),
            const SpaceH16(),
            TransactionDetailsItem(
              text: intl.gift_history_to,
              value: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TransactionDetailsValueText(
                      textAlign: TextAlign.right,
                      text: receiverContact,
                    ),
                  ),
                  const SpaceW10(),
                  SIconButton(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: receiverContact,
                        ),
                      );

                      onCopyAction('Gift Send');
                    },
                    defaultIcon: const SCopyIcon(),
                    pressedIcon: const SCopyPressedIcon(),
                  ),
                ],
              ),
            ),
            const SpaceH16(),
            TransactionDetailsItem(
              text: intl.fee,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: volumeFormat(
                      prefix: currency.prefixSymbol,
                      decimal: transactionListItem.withdrawalInfo?.feeAmount ??
                          Decimal.zero,
                      accuracy: currency.accuracy,
                      symbol: currency.symbol,
                    ),
                  ),
                ],
              ),
            ),
            const SpaceH16(),
            TransactionDetailsStatus(
              status: transactionListItem.status,
              reason: transactionListItem.giftSendInfo?.declineReason,
            ),
            if (transactionListItem.status == Status.inProgress) ...[
              const SpaceH40(),
              SPrimaryButton1(
                active: true,
                name: intl.gift_history_remind,
                onTap: () {
                  shareGiftResultBottomSheet(
                    context: context,
                    amount: Decimal.parse(
                      '${transactionListItem.balanceChange}'
                          .replaceAll('-', ''),
                    ),
                    currency: currency,
                  );
                },
              ),
              const SpaceH10(),
              STextButton1(
                active: true,
                name: intl.gift_history_cancel_transaction,
                onTap: () {
                  sShowAlertPopup(
                    context,
                    primaryText: '${intl.gift_history_cancel_transaction}?',
                    secondaryText: intl.gift_history_are_you_sure,
                    primaryButtonName: intl.gift_history_yes_cancel,
                    secondaryButtonName: intl.gift_history_no,
                    primaryButtonType: SButtonType.primary3,
                    onPrimaryButtonTap: () async {
                      store.startLoadingImmediately();
                      Navigator.pop(context);
                      await getIt
                          .get<SNetwork>()
                          .simpleNetworking
                          .getWalletModule()
                          .cancelGift(
                            transactionListItem.giftSendInfo?.transferId ?? '',
                          );
                      store.finishLoading();
                      Navigator.pop(context);
                    },
                    onSecondaryButtonTap: () => Navigator.pop(context),
                  );
                },
              ),
            ],
            const SpaceH42(),
          ],
        ),
      ),
    );
  }
}
