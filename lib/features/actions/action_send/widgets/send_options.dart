import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

void showSendOptions(
  BuildContext context,
  CurrencyModel currency, {
  bool navigateBack = true,
}) {
  if (navigateBack) {
    Navigator.pop(context);
  }

  sShowBasicModalBottomSheet(
    context: context,
    then: (value) {},
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

class _SendOptions extends StatelessObserverWidget {
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
          name: intl.sendOptions_actionItemName1,
          description: intl.sendOptions_actionItemDescription1,
          onTap: () {

            sRouter.navigate(
              SendByPhoneInputRouter(
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
            Navigator.pop(context);

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
