import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../models/currency_model.dart';
import '../../../currency_send/view/screens/send_input_phone.dart';
import '../../../currency_withdraw/model/withdrawal_model.dart';
import '../../../currency_withdraw/view/currency_withdraw.dart';

void showSendOptions(BuildContext context, CurrencyModel currency) {
  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    pinned: const SBottomSheetHeader(
      name: 'Send to',
    ),
    children: [
      _SendOptions(
        currency: currency,
      ),
    ],
  );
}

class _SendOptions extends StatelessWidget {
  const _SendOptions({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SActionItem(
          icon: const SPhoneIcon(),
          name: 'Send by phone',
          description: 'Just choose friend from contacts',
          onTap: () {
            navigatorPushReplacement(
              context,
              SendInputPhone(
                withdrawal: WithdrawalModel(
                  currency: currency,
                ),
              ),
            );
          },
        ),
        SActionItem(
          icon: const SWalletIcon(),
          name: 'Send by wallet',
          description: 'Send to any wallet (address required)',
          onTap: () {
            navigatorPushReplacement(
              context,
              CurrencyWithdraw(
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
