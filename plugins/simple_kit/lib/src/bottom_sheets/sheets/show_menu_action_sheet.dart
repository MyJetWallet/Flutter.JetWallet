import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

void sShowMenuActionSheet({
  bool isDepositAvailable = true,
  bool isWithdrawAvailable = true,
  bool isSendAvailable = true,
  bool isReceiveAvailable = true,
  required BuildContext context,
  required void Function() onBuy,
  required void Function() onSell,
  required void Function() onConvert,
  required void Function() onDeposit,
  required void Function() onWithdraw,
  required void Function() onSend,
  required void Function() onReceive,
  required void Function() onDissmis,
  required void Function() whenComplete,
  required AnimationController transitionAnimationController,
  required bool isNotEmptyBalance,
}) {
  return sShowBasicBottomSheet(
    context: context,
    onDissmis: onDissmis,
    whenColmplete: whenComplete,
    removePinnedPadding: true,
    onWillPop: () => Future.value(true),
    transitionAnimationController: transitionAnimationController,
    children: [
      SActionItem(
        onTap: onBuy,
        icon: const SActionBuyIcon(),
        name: 'Buy',
        description: 'Buy any crypto available on the platform',
      ),
      if (isNotEmptyBalance) ...[
        SActionItem(
          onTap: onSell,
          icon: const SActionSellIcon(),
          name: 'Sell',
          description: 'Sell crypto from your portfolio',
        ),
        SActionItem(
          onTap: onConvert,
          icon: const SActionConvertIcon(),
          name: 'Convert',
          description: 'Quickly swap one crypto for another',
        ),
      ],
      if (isDepositAvailable) ...[
        SActionItem(
          onTap: onDeposit,
          icon: const SActionDepositIcon(),
          name: 'Deposit',
          description: 'Deposit with fiat or crypto',
        ),
      ],
      if (isNotEmptyBalance) ...[
        if (isWithdrawAvailable) ...[
          SActionItem(
            onTap: onWithdraw,
            icon: const SActionWithdrawIcon(),
            name: 'Withdraw',
            description: 'Withdraw crypto to an external account',
          ),
        ],
        if (isSendAvailable) ...[
          SActionItem(
            onTap: onSend,
            icon: const SActionSendIcon(),
            name: 'Send',
            description: 'Send crypto to another wallet',
          ),
        ],
      ],
      if (isReceiveAvailable) ...[
        SActionItem(
          onTap: onReceive,
          icon: const SActionReceiveIcon(),
          name: 'Receive',
          description: 'Receive crypto from another wallet',
        ),
      ],
      const SpaceH20(),
    ],
  );
}
