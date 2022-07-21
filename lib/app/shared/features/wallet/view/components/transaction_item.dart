import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/operation_history/model/operation_history_response_model.dart';

import '../../../../../../shared/providers/service_providers.dart';
import '../../helper/is_operation_support_copy.dart';
import '../../notifier/cancel_transaction_notifier/transaction_cancel_notipod.dart';
import 'wallet_body/components/transactions_list_item/components/transaction_details/buy_sell_details.dart';
import 'wallet_body/components/transactions_list_item/components/transaction_details/buy_simplex_details.dart';
import 'wallet_body/components/transactions_list_item/components/transaction_details/components/common_transaction_details_block.dart';
import 'wallet_body/components/transactions_list_item/components/transaction_details/deposit_details.dart';
import 'wallet_body/components/transactions_list_item/components/transaction_details/earning_deposit_details.dart';
import 'wallet_body/components/transactions_list_item/components/transaction_details/earning_withdrawal_details.dart';
import 'wallet_body/components/transactions_list_item/components/transaction_details/receive_details.dart';
import 'wallet_body/components/transactions_list_item/components/transaction_details/recurring_buy_details.dart';
import 'wallet_body/components/transactions_list_item/components/transaction_details/transfer_details.dart';
import 'wallet_body/components/transactions_list_item/components/transaction_details/withdraw_details.dart';

class TransactionItem extends HookWidget {
  const TransactionItem({
    Key? key,
    required this.transactionListItem,
  }) : super(key: key);
  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final cancelTransferN = useProvider(transferCancelNotipod.notifier);
    final cancelTransfer = useProvider(transferCancelNotipod);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
    );
    final copiedText = useState('');

    final scaleAnimation = Tween(
      begin: 64.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    final translateOffset = Offset(0, scaleAnimation.value);
    useListenable(animationController);

    void _onCopyAction() {
      animationController.forward().then(
        (_) async {
          await Future.delayed(const Duration(seconds: 2));
          await animationController.animateBack(0);
        },
      );
    }

    return Column(
      children: [
        CommonTransactionDetailsBlock(
          transactionListItem: transactionListItem,
        ),
        Stack(
          children: [
            Column(
              children: [
                if (isOperationSupportCopy(transactionListItem))
                  Transform.translate(
                    offset: translateOffset,
                    child: Container(
                      color: colors.greenLight,
                      height: 64.0,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          '${copiedText.value} ${intl.transactionItem_copied}',
                          style: sBodyText1Style.copyWith(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (transactionListItem.operationType ==
                    OperationType.deposit) ...[
                  Material(
                    color: colors.white,
                    child: DepositDetails(
                      transactionListItem: transactionListItem,
                      onCopyAction: (String text) {
                        copiedText.value = text;
                        _onCopyAction();
                      },
                    ),
                  ),
                ],
                if (transactionListItem.operationType ==
                    OperationType.withdraw) ...[
                  Material(
                    color: colors.white,
                    child: WithdrawDetails(
                      transactionListItem: transactionListItem,
                      onCopyAction: (String text) {
                        copiedText.value = text;
                        _onCopyAction();
                      },
                    ),
                  ),
                ],
                if (transactionListItem.operationType ==
                    OperationType.simplexBuy) ...[
                  Material(
                    color: colors.white,
                    child: BuySimplexDetails(
                      transactionListItem: transactionListItem,
                      onCopyAction: (String text) {
                        copiedText.value = text;
                        _onCopyAction();
                      },
                    ),
                  ),
                ],
                if (transactionListItem.operationType ==
                    OperationType.recurringBuy) ...[
                  Material(
                    color: colors.white,
                    child: RecurringBuyDetails(
                      transactionListItem: transactionListItem,
                      onCopyAction: (String text) {
                        copiedText.value = text;
                        _onCopyAction();
                      },
                    ),
                  ),
                ],
                if (transactionListItem.operationType ==
                    OperationType.earningDeposit) ...[
                  Material(
                    color: colors.white,
                    child: EarningDepositDetails(
                      transactionListItem: transactionListItem,
                      onCopyAction: (String text) {
                        copiedText.value = text;
                        _onCopyAction();
                      },
                    ),
                  ),
                ],
                if (transactionListItem.operationType ==
                    OperationType.earningWithdrawal) ...[
                  Material(
                    color: colors.white,
                    child: EarningWithdrawalDetails(
                      transactionListItem: transactionListItem,
                      onCopyAction: (String text) {
                        copiedText.value = text;
                        _onCopyAction();
                      },
                    ),
                  ),
                ],
                if (transactionListItem.operationType == OperationType.buy ||
                    transactionListItem.operationType ==
                        OperationType.sell) ...[
                  Material(
                    color: colors.white,
                    child: BuySellDetails(
                      transactionListItem: transactionListItem,
                      onCopyAction: (String text) {
                        copiedText.value = text;
                        _onCopyAction();
                      },
                    ),
                  ),
                ],
                if (transactionListItem.operationType ==
                    OperationType.transferByPhone) ...[
                  Material(
                    color: colors.white,
                    child: TransferDetails(
                      transactionListItem: transactionListItem,
                    ),
                  ),
                ],
                if (transactionListItem.operationType ==
                    OperationType.receiveByPhone) ...[
                  Material(
                    color: colors.white,
                    child: ReceiveDetails(
                      transactionListItem: transactionListItem,
                    ),
                  ),
                ],
                Visibility(
                  visible: transactionListItem.status == Status.inProgress &&
                      transactionListItem.transferByPhoneInfo?.transferId !=
                          null,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                    child: SSecondaryButton1(
                      active: !cancelTransfer.loading,
                      name: intl.transactionItem_cancel_cancel,
                      onTap: () {
                        cancelTransferN.cancelTransaction(
                          transactionListItem.transferByPhoneInfo?.transferId,
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
