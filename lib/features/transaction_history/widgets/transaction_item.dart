import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/transaction_history/store/transaction_cancel_store.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/add_cash_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/buy_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/buy_p2p_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/buy_vouncher_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/card_purchase_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/card_refund_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/card_withdrawal_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/components/common_transaction_details_block.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/deposit_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/earn_send_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/gift_receive_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/gift_send_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/iban_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/receive_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/referral_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/sell_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/swap_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/transfer_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/withdraw_details.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:jetwallet/utils/helpers/find_blockchain_by_descr.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../core/services/device_size/device_size.dart';
import '../../../core/services/notification_service.dart';
import '../../../utils/helpers/widget_size_from.dart';
import '../../wallet/helper/is_operation_support_copy.dart';
import 'transaction_details/bank_transfer_details.dart';
import 'transaction_details/iban_send_details.dart';
import 'transaction_details/send_globally_details.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    super.key,
    required this.transactionListItem,
    required this.source,
  });

  final OperationHistoryItem transactionListItem;
  final TransactionItemSource source;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> scaleAnimation;
  String copiedText = '';

  @override
  void initState() {
    // animationController intentionally is not disposed,
    // because bottomSheet will dispose it on its own
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
    );
    final deviceSize = sDeviceSize;
    scaleAnimation = Tween<Offset>(
      begin: widgetSizeFrom(deviceSize) == SWidgetSize.small ? const Offset(0.0, 40.0) : const Offset(0.0, 60.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
    scaleAnimation.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final cancelTransfer = TransactionCancelStore();
    final deviceSize = sDeviceSize;

    void onCopyAction() {
      sNotification.showError(
        intl.copy_message,
        id: 1,
        isError: false,
      );
    }

    return Column(
      children: [
        CommonTransactionDetailsBlock(
          transactionListItem: widget.transactionListItem,
          source: widget.source,
        ),
        Stack(
          children: [
            Column(
              children: [
                if (widget.transactionListItem.operationType == OperationType.bankingAccountWithdrawal ||
                    widget.transactionListItem.operationType == OperationType.bankingBuy ||
                    widget.transactionListItem.operationType == OperationType.cryptoBuy ||
                    widget.transactionListItem.operationType == OperationType.swapBuy ||
                    widget.transactionListItem.operationType == OperationType.swapSell ||
                    widget.transactionListItem.operationType == OperationType.bankingSell ||
                    widget.transactionListItem.operationType == OperationType.bankingAccountDeposit ||
                    widget.transactionListItem.operationType == OperationType.withdraw ||
                    widget.transactionListItem.operationType == OperationType.giftSend ||
                    widget.transactionListItem.operationType == OperationType.giftReceive ||
                    widget.transactionListItem.operationType == OperationType.rewardPayment ||
                    widget.transactionListItem.operationType == OperationType.deposit ||
                    widget.transactionListItem.operationType == OperationType.sendGlobally ||
                    widget.transactionListItem.operationType == OperationType.cardPurchase ||
                    widget.transactionListItem.operationType == OperationType.cardWithdrawal ||
                    widget.transactionListItem.operationType == OperationType.cardRefund ||
                    widget.transactionListItem.operationType == OperationType.bankingTransfer ||
                    widget.transactionListItem.operationType == OperationType.cardBankingSell ||
                    widget.transactionListItem.operationType == OperationType.earnReserve ||
                    widget.transactionListItem.operationType == OperationType.earnSend ||
                    widget.transactionListItem.operationType == OperationType.earnDeposit ||
                    widget.transactionListItem.operationType == OperationType.earnPayroll ||
                    widget.transactionListItem.operationType == OperationType.earnWithdrawal ||
                    widget.transactionListItem.operationType == OperationType.cardTransfer ||
                    widget.transactionListItem.operationType == OperationType.buyPrepaidCard ||
                    widget.transactionListItem.operationType == OperationType.p2pBuy ||
                    widget.transactionListItem.operationType == OperationType.jarDeposit ||
                    widget.transactionListItem.operationType == OperationType.jarWithdrawal ||
                    widget.transactionListItem.operationType == OperationType.bankingSellWithWithdrawal) ...[
                  const SizedBox.shrink(),
                ] else if (widget.transactionListItem.operationType != OperationType.sendGlobally) ...[
                  if (isOperationSupportCopy(widget.transactionListItem))
                    Transform.translate(
                      offset: scaleAnimation.value,
                      child: Container(
                        color: colors.greenLight,
                        height: widgetSizeFrom(deviceSize) == SWidgetSize.small ? 40.0 : 60.0,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            '$copiedText ${intl.transactionItem_copied}',
                            style: STStyles.body1Medium.copyWith(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ),
                ] else ...[
                  const SpaceH32(),
                ],
                if (widget.transactionListItem.operationType == OperationType.deposit ||
                    widget.transactionListItem.operationType == OperationType.jarDeposit) ...[
                  Material(
                    color: colors.white,
                    child: DepositDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.withdraw ||
                    widget.transactionListItem.operationType == OperationType.jarWithdrawal) ...[
                  Material(
                    color: colors.white,
                    child: WithdrawDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.sendGlobally) ...[
                  Material(
                    color: colors.white,
                    child: SendGloballyDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.bankingAccountWithdrawal) ...[
                  Material(
                    color: colors.white,
                    child: IbanSendDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.cardPurchase) ...[
                  Material(
                    color: colors.white,
                    child: CardPurchaseDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.cardRefund) ...[
                  Material(
                    color: colors.white,
                    child: CardRefundDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.cardWithdrawal) ...[
                  Material(
                    color: colors.white,
                    child: CardWithdrawalDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.bankingBuy ||
                    widget.transactionListItem.operationType == OperationType.cryptoBuy) ...[
                  Material(
                    color: colors.white,
                    child: BuyDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.bankingSell ||
                    widget.transactionListItem.operationType == OperationType.cardBankingSell) ...[
                  Material(
                    color: colors.white,
                    child: SellDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.swapBuy ||
                    widget.transactionListItem.operationType == OperationType.swapSell) ...[
                  Material(
                    color: colors.white,
                    child: SwapDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.receiveByPhone) ...[
                  Material(
                    color: colors.white,
                    child: ReceiveDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.bankingAccountDeposit) ...[
                  Material(
                    color: colors.white,
                    child: AddCashDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.ibanDeposit) ...[
                  Material(
                    color: colors.white,
                    child: IbanDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.rewardPayment) ...[
                  Material(
                    color: colors.white,
                    child: ReferralDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.p2pBuy) ...[
                  Material(
                    color: colors.white,
                    child: BuyP2PDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.giftSend) ...[
                  Material(
                    color: colors.white,
                    child: GiftSendDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.giftReceive) ...[
                  Material(
                    color: colors.white,
                    child: GiftReceiveDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.bankingTransfer ||
                    widget.transactionListItem.operationType == OperationType.cardTransfer) ...[
                  Material(
                    color: colors.white,
                    child: TransferDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.earnReserve ||
                    widget.transactionListItem.operationType == OperationType.earnSend) ...[
                  Material(
                    color: colors.white,
                    child: EarnSendDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.buyPrepaidCard) ...[
                  Material(
                    color: colors.white,
                    child: BuyVouncherDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                if (widget.transactionListItem.operationType == OperationType.bankingSellWithWithdrawal) ...[
                  Material(
                    color: colors.white,
                    child: BankTransferDetails(
                      transactionListItem: widget.transactionListItem,
                      onCopyAction: (String text) {
                        setState(() {
                          copiedText = text;
                        });

                        onCopyAction();
                      },
                    ),
                  ),
                ],
                Visibility(
                  visible: (widget.transactionListItem.operationType == OperationType.jarWithdrawal &&
                          isTXIDExist(widget.transactionListItem) != null) ||
                      (isTXIDExist(widget.transactionListItem) != null &&
                          getBlockChainURL(widget.transactionListItem).isNotEmpty &&
                          !checkTransactionIsInternal(widget.transactionListItem)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 42,
                    ),
                    child: SIconTextButton(
                      disabled: cancelTransfer.loading,
                      text: intl.open_in_explorer,
                      icon: Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                        ),
                        child: const SNetworkIcon(),
                      ),
                      onTap: () async {
                        if (!await launchUrlString(
                          getBlockChainURL(
                            widget.transactionListItem,
                          ),
                        )) {
                          throw Exception('Could not launch');
                        }
                      },
                      mainAxisSize: MainAxisSize.max,
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.transactionListItem.status == Status.inProgress &&
                      widget.transactionListItem.transferByPhoneInfo?.transferId != null,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 24,
                    ),
                    child: SSecondaryButton1(
                      active: !cancelTransfer.loading,
                      name: intl.transactionItem_cancel_cancel,
                      onTap: () {
                        cancelTransfer.cancelTransaction(
                          widget.transactionListItem.transferByPhoneInfo?.transferId,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
