import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

void sShowMenuActionSheet({
  bool isDepositAvailable = true,
  bool isWithdrawAvailable = true,
  bool isSendAvailable = true,
  bool isReceiveAvailable = true,
  required BuildContext context,
  required void Function(bool isFromBuyFromCard) onBuy,
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
      if (!isNotEmptyBalance)
        SActionItem(
          onTap: () => onBuy(true),
          icon: const SActionDepositIcon(),
          name: 'Buy from card',
          description: 'Buy crypto with your bank card',
        ),
      if (isNotEmptyBalance)
        SActionItem(
          onTap: () => onBuy(false),
          icon: const SActionBuyIcon(),
          name: 'Buy',
          description: 'Buy crypto',
        ),
      if (isNotEmptyBalance) ...[
        SActionItem(
          onTap: onSell,
          icon: const SActionSellIcon(),
          name: 'Sell',
          description: 'Sell crypto',
        ),
        SActionItem(
          onTap: onConvert,
          icon: const SActionConvertIcon(),
          name: 'Convert',
          description: 'Quickly swap one crypto for another',
        ),
        SActionItem(
          onTap: () => onBuy(true),
          icon: const SActionDepositIcon(),
          name: 'Buy from card',
          description: 'Buy crypto with your bank card',
        ),
      ],
      if (isReceiveAvailable) ...[
        SActionItem(
          onTap: onReceive,
          icon: const SActionReceiveIcon(),
          name: 'Receive',
          description: 'Receive crypto from another wallet',
        ),
      ],
      if (isSendAvailable && isNotEmptyBalance) ...[
        SActionItem(
          onTap: onSend,
          icon: const SActionSendIcon(),
          name: 'Send',
          description: 'Send crypto to another wallet or phone',
        ),
      ],
      const SpaceH20(),
    ],
  );
}
