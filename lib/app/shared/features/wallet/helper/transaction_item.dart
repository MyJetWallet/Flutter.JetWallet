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
    final opacity = useState(0.0);
    final copiedText = useState('');

    void _onCopyAction() {
      animationController.forward().then(
        (_) async {
          opacity.value = 1;
          await Future.delayed(const Duration(seconds: 2));
          opacity.value = 0;
          await animationController.animateBack(0);
        },
      );
    }

    return Column(
      children: [
        CommonTransactionDetailsBlock(
          transactionListItem: transactionListItem,
        ),
        Transform.translate(
          offset: translateOffset,
          child: Container(
            color: colors.greenLight.withOpacity(opacity.value),
            height: 64.0,
            width: double.infinity,
            child: Center(
              child: Text(
                '${copiedText.value} copied',
                style: sBodyText1Style.copyWith(
                  color: Colors.green.withOpacity(opacity.value),
                ),
              ),
            ),
          ),
        ),
        if (transactionListItem.operationType ==
            OperationType.deposit) ...[
          DepositDetails(
            transactionListItem: transactionListItem,
            onCopyAction: (String text) {
              copiedText.value = text;
              _onCopyAction();
            },
          ),
        ],
        if (transactionListItem.operationType ==
            OperationType.withdraw) ...[
          WithdrawDetails(
            transactionListItem: transactionListItem,
            onCopyAction: (String text) {
              copiedText.value = text;
              _onCopyAction();
            },
          ),
        ],
        if (transactionListItem.operationType == OperationType.buy ||
            transactionListItem.operationType == OperationType.sell) ...[
          BuySellDetails(
            transactionListItem: transactionListItem,
            onCopyAction: (String text) {
              copiedText.value = text;
              _onCopyAction();
            },
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
        const SpaceH40(),
      ],
    );
  }
}
