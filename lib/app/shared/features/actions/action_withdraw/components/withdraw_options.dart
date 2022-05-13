import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../models/currency_model.dart';
import '../../../currency_withdraw/model/withdrawal_dictionary_model.dart';
import '../../../currency_withdraw/model/withdrawal_model.dart';
import '../../../currency_withdraw/view/currency_withdraw.dart';

void showWithdrawOptions(BuildContext context, CurrencyModel currency) {
  final intl = context.read(intlPod);

  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    pinned: SBottomSheetHeader(
      name: intl.sendTo,
    ),
    children: [
      _WithdrawOptions(
        currency: currency,
      ),
    ],
  );
}

class _WithdrawOptions extends HookWidget {
  const _WithdrawOptions({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

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
            name: intl.wireTransfer,
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
            description: '${currency.symbol} ${intl.wallet1}',
            onTap: () {
              navigatorPushReplacement(
                context,
                CurrencyWithdraw(
                  withdrawal: WithdrawalModel(
                    currency: currency,
                    dictionary: const WithdrawalDictionaryModel.withdraw(),
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
