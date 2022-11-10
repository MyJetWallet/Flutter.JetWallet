import 'package:flutter/material.dart';
import 'package:simple_kit/modules/asset_items/simple_action_item.dart';
import 'package:simple_kit/modules/bottom_sheets/components/basic_bottom_sheet/show_basic_bottom_sheet.dart';
import 'package:simple_kit/simple_kit.dart';

// ignore: long-method
void sShowMenuActionSheet({
  bool isBuyAvailable = true,
  bool isDepositAvailable = true,
  bool isWithdrawAvailable = true,
  bool isBuyFromCardAvailable = true,
  bool isReceiveAvailable = true,
  bool isSendAvailable = true,
  bool isConvertAvailable = true,
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
      if (isBuyAvailable)
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
        if (isConvertAvailable) ...[
          SActionItem(
            onTap: onConvert,
            icon: const SActionConvertIcon(),
            name: actionItemLocalized[3]['name']!,
            description: actionItemLocalized[3]['description']!,
          ),
        ],
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
      SActionItem(
        onTap: onSend,
        icon: const SActionSendIcon(),
        name: actionItemLocalized[6]['name']!,
        description: actionItemLocalized[6]['description']!,
      ),
      const SpaceH20(),
    ],
  );
}
