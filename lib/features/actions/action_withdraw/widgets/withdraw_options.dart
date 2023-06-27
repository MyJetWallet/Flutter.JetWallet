import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';

void showWithdrawOptions(BuildContext context, CurrencyModel currency) {
  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    pinned: SBottomSheetHeader(
      name: intl.withdrawOptions_sendTo,
    ),
    children: [
      _WithdrawOptions(
        currency: currency,
      ),
    ],
  );
}

class _WithdrawOptions extends StatelessWidget {
  const _WithdrawOptions({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TODO Add Credit Card feature
        // SAssetItem(
        //   icon: SActionDepositIcon(
        //     color: color.black,
        //   ),
        //   isCreditCard: true,
        //   name: 'Mastercard',
        //   amount: '•••• 1212',
        //   description: 'Exp: 01/24',
        //   helper: 'Lim: \$10 / \$10000',
        //   onTap: () {
        //
        //   },
        // ),
        // TODO Add ADV Cash feature
        // SActionItem(
        //   icon: const SAdvCashIcon(),
        //   name: 'ADV Cash',
        //   description: 'Multifunctional payment hub',
        //   helper: 'No fee',
        //   onTap: () {
        //     // TODO Add ADV Cash feature
        //   },
        // ),
        if (currency.supportsSepaWithdrawal)
          SActionItem(
            icon: const SWireIcon(),
            name: intl.withdrawOptions_wireTransfer,
            description: intl.withdrawOptions_actionItemDescription1,
            helper: intl.noFee,
            onTap: () {
              // TODO Add Sepa feature
            },
          ),
        if (currency.supportsCryptoWithdrawal)
          SActionItem(
            icon: const SWalletIcon(),
            name: intl.withdrawOptions_actionItemName1,
            description: '${currency.symbol} ${intl.withdrawOptions_wallet}',
            onTap: () {
              sRouter.push(
                WithdrawRouter(
                  withdrawal: WithdrawalModel(
                    currency: currency,
                  ),
                ),
              );
            },
          ),
        const SpaceH40(),
      ],
    );
  }
}
