import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

void sShowMenuActionSheet({
  bool isBuyAvailable = true,
  bool isDepositAvailable = true,
  bool isWithdrawAvailable = true,
  bool isBuyFromCardAvailable = true,
  bool isReceiveAvailable = true,
  bool isSendAvailable = true,
  required BuildContext context,
  required void Function() onBuy,
  required void Function() onBuyFromCard,
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
  required List<Map<String, String>> actionItemLocalized,
}) {
  return sShowBasicBottomSheet(
    context: context,
    onDissmis: onDissmis,
    whenColmplete: whenComplete,
    removePinnedPadding: true,
    onWillPop: () => Future.value(true),
    transitionAnimationController: transitionAnimationController,
    children: [
      if (isNotEmptyBalance && isBuyAvailable)
        SActionItem(
          onTap: () => onBuy(),
          icon: const SActionBuyIcon(),
          name: actionItemLocalized[1]['name']!,
          description: actionItemLocalized[1]['description']!,
        ),
      if (isNotEmptyBalance) ...[
        SActionItem(
          onTap: onSell,
          icon: const SActionSellIcon(),
          name: actionItemLocalized[2]['name']!,
          description: actionItemLocalized[2]['description']!,
        ),
        SActionItem(
          onTap: onConvert,
          icon: const SActionConvertIcon(),
          name: actionItemLocalized[3]['name']!,
          description: actionItemLocalized[3]['description']!,
        ),
      ],
      if (isBuyFromCardAvailable)
        SActionItem(
          onTap: () => onBuyFromCard(),
          icon: const SActionDepositIcon(),
          name: actionItemLocalized[4]['name']!,
          description: actionItemLocalized[4]['description']!,
        ),
      if (isReceiveAvailable) ...[
        SActionItem(
          onTap: onReceive,
          icon: const SActionReceiveIcon(),
          name: actionItemLocalized[5]['name']!,
          description: actionItemLocalized[5]['description']!,
        ),
      ],
      if (isSendAvailable && isNotEmptyBalance) ...[
        SActionItem(
          onTap: onSend,
          icon: const SActionSendIcon(),
          name: actionItemLocalized[6]['name']!,
          description: actionItemLocalized[6]['description']!,
        ),
      ],
      const SpaceH20(),
    ],
  );
}
