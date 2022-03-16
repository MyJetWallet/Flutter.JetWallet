import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../view/components/wallet_body/components/transactions_list_item/components/transaction_details/buy_sell_details.dart';
import '../view/components/wallet_body/components/transactions_list_item/components/transaction_details/components/common_transaction_details_block.dart';
import '../view/components/wallet_body/components/transactions_list_item/components/transaction_details/deposit_details.dart';
import '../view/components/wallet_body/components/transactions_list_item/components/transaction_details/receive_details.dart';
import '../view/components/wallet_body/components/transactions_list_item/components/transaction_details/transfer_details.dart';
import '../view/components/wallet_body/components/transactions_list_item/components/transaction_details/withdraw_details.dart';

class TransactionItem extends HookWidget {
  const TransactionItem({
    Key? key,
    required this.transactionListItem,
  }) : super(key: key);
  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
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
                if (transactionListItem.operationType !=
                    OperationType.paidInterestRate)
                  Transform.translate(
                    offset: translateOffset,
                    child: Container(
                      color: colors.greenLight,
                      height: 64.0,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          '${copiedText.value} copied',
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
                    color: Colors.white,
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
                    color: Colors.white,
                    child: WithdrawDetails(
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
                    color: Colors.white,
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
                  TransferDetails(
                    transactionListItem: transactionListItem,
                  ),
                ],
                if (transactionListItem.operationType ==
                    OperationType.receiveByPhone) ...[
                  ReceiveDetails(
                    transactionListItem: transactionListItem,
                  ),
                ],
              ],
            ),
          ],
        ),
        const SpaceH40(),
      ],
    );
  }
}
