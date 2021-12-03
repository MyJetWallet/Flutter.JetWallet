import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../models/currency_model.dart';
import '../../../currency_withdraw/model/withdrawal_dictionary_model.dart';
import '../../../currency_withdraw/model/withdrawal_model.dart';
import '../../../currency_withdraw/view/currency_withdraw.dart';

void showWithdrawOptions(BuildContext context, CurrencyModel currency) {
  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    pinned: const SBottomSheetHeader(
      name: 'Send to',
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
    final color = useProvider(sColorPod);

    return Column(
      children: [
        SAssetItem(
          icon: SActionDepositIcon(
            color: color.black,
          ),
          isCreditCard: true,
          name: 'Mastercard',
          amount: '•••• 1212',
          description: 'Exp: 01/24',
          helper: 'Lim: \$10 / \$10000',
          onTap: () {
            // TODO Add Credit Card feature
          },
        ),
        SActionItem(
          icon: const SWireIcon(),
          name: 'Wire transfer',
          description: 'SEPA',
          helper: 'No fee',
          onTap: () {
            // TODO Add Sepa feature
          },
        ),
        SActionItem(
          icon: const SAdvCashIcon(),
          name: 'ADV Cash',
          description: 'Multifunctional payment hub',
          helper: 'No fee',
          onTap: () {
            // TODO Add ADV Cash feature
          },
        ),
        SActionItem(
          icon: const SWalletIcon(),
          name: 'Crypto Wallet',
          description: 'BTC Wallet',
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
