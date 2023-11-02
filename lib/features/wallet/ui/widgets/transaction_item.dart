import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/wallet/store/transaction_cancel_store.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/buy_crypto_details.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/buy_p2p_details.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/buy_simplex_details.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/common_transaction_details_block.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/deposit_details.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/deposit_nft_details.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/gift_receive_details.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/gift_send_details.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/iban_details.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/receive_details.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/referral_details.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/buy_details.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/transfer_details.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/withdraw_details.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/withdraw_nft_details.dart';
import 'package:jetwallet/utils/helpers/find_blockchain_by_descr.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../core/services/device_size/device_size.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../utils/helpers/check_local_operation.dart';
import '../../../../utils/helpers/widget_size_from.dart';
import '../../helper/is_operation_support_copy.dart';
import 'wallet_body/widgets/transactions_list_item/components/transaction_details/buy_sell_details.dart';
import 'wallet_body/widgets/transactions_list_item/components/transaction_details/iban_send_details.dart';
import 'wallet_body/widgets/transactions_list_item/components/transaction_details/sell_nft_details.dart';
import 'wallet_body/widgets/transactions_list_item/components/transaction_details/send_globally_details.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    super.key,
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

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
    final isLocal = widget.transactionListItem.operationType == OperationType.cryptoBuy &&
        isOperationLocal(
          widget.transactionListItem.cryptoBuyInfo?.paymentMethod ?? PaymentMethodType.unsupported,
        );

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
        ),
        Stack(
          children: [
            Column(
              children: [
                if (widget.transactionListItem.operationType == OperationType.bankingAccountWithdrawal ||
                    widget.transactionListItem.operationType == OperationType.bankingBuy ||
                    widget.transactionListItem.operationType == OperationType.swap ||
                    widget.transactionListItem.operationType == OperationType.bankingSell) ...[
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
                            style: sBodyText1Style.copyWith(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ),
                ] else ...[
                  const SpaceH32(),
                ],
                if (widget.transactionListItem.operationType == OperationType.deposit) ...[
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
                if (widget.transactionListItem.operationType == OperationType.withdraw) ...[
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
                if (widget.transactionListItem.operationType == OperationType.bankingBuy ||
                    widget.transactionListItem.operationType == OperationType.swap ||
                    widget.transactionListItem.operationType == OperationType.bankingSell) ...[
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
                if (widget.transactionListItem.operationType == OperationType.simplexBuy) ...[
                  Material(
                    color: colors.white,
                    child: BuySimplexDetails(
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
                if (widget.transactionListItem.operationType == OperationType.buy ||
                    widget.transactionListItem.operationType == OperationType.sell) ...[
                  Material(
                    color: colors.white,
                    child: BuySellDetails(
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
                if (widget.transactionListItem.operationType == OperationType.transferByPhone) ...[
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
                if ((widget.transactionListItem.operationType == OperationType.cryptoBuy && !isLocal) ||
                    widget.transactionListItem.operationType == OperationType.buyGooglePay ||
                    widget.transactionListItem.operationType == OperationType.buyApplePay) ...[
                  Material(
                    color: colors.white,
                    child: BuyCryptoDetails(
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
                if (widget.transactionListItem.operationType == OperationType.cryptoBuy && isLocal) ...[
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
                if (widget.transactionListItem.operationType == OperationType.nftSell) ...[
                  Material(
                    color: colors.white,
                    child: SellNftDetails(
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
                if (widget.transactionListItem.operationType == OperationType.nftWithdrawal ||
                    widget.transactionListItem.operationType == OperationType.nftWithdrawalFee) ...[
                  Material(
                    color: colors.white,
                    child: WithdrawNftDetails(
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
                if (widget.transactionListItem.operationType == OperationType.nftDeposit) ...[
                  Material(
                    color: colors.white,
                    child: DepositNftDetails(
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
                Visibility(
                  visible: isTXIDExist(widget.transactionListItem) != null &&
                      getBlockChainURL(widget.transactionListItem).isNotEmpty &&
                      !checkTransactionIsInternal(widget.transactionListItem),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 42,
                    ),
                    child: SSecondaryButton1(
                      active: !cancelTransfer.loading,
                      name: intl.open_in_explorer,
                      icon: const SNetworkIcon(),
                      onTap: () async {
                        if (!await launchUrlString(
                          getBlockChainURL(
                            widget.transactionListItem,
                          ),
                        )) {
                          throw Exception('Could not launch');
                        }
                      },
                      textColor: colors.blue,
                      borderColor: colors.blue,
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
