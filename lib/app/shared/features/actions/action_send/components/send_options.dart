import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../models/currency_model.dart';
import '../../../currency_withdraw/model/withdrawal_model.dart';
import '../../../currency_withdraw/view/currency_withdraw.dart';
import '../../../send_by_phone/view/screens/send_by_phone_input/send_by_phone_input.dart';

void showSendOptions(
  BuildContext context,
  CurrencyModel currency,
) {
  final intl = context.read(intlPod);
  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    then: (value) {
      sAnalytics.sendToViewClose();
    },
    pinned: SBottomSheetHeader(
      name: intl.sendOptions_sendTo,
    ),
    children: [
      _SendOptions(
        currency: currency,
      ),
    ],
  );
}

class _SendOptions extends HookWidget {
  const _SendOptions({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return Column(
      children: [
        SActionItem(
          icon: const SPhoneIcon(),
          name: intl.sendOptions_actionItemName1,
          description: intl.sendOptions_actionItemDescription1,
          onTap: () {
            sAnalytics.sendChoosePhone();
            navigatorPushReplacement(
              context,
              SendByPhoneInput(
                currency: currency,
              ),
            );
          },
        ),
        SActionItem(
          icon: const SWalletIcon(),
          name: intl.sendOptions_actionItemName2,
          description: intl.sendOptions_actionItemDescription2,
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
