import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../components/basic_bottom_sheet/basic_bottom_sheet.dart';
import '../components/simple_action_sheet_item.dart';

void sShowMenuActionSheet({
  required BuildContext context,
  required void Function() onBuy,
  required void Function() onSell,
  required void Function() onConvert,
  required void Function() onDeposit,
  required void Function() onWithdraw,
  required void Function() onSend,
  required void Function() onReceive,
}) {
  return showBasicBottomSheet(
    context: context,
    removeBottomHeaderPadding: true,
    children: [
      SActionSheetItem(
        onTap: onBuy,
        icon: const SActionBuyIcon(),
        name: 'Buy',
        description: 'Buy crypto with your local currency',
      ),
      SActionSheetItem(
        onTap: onSell,
        icon: const SActionSellIcon(),
        name: 'Sell',
        description: 'Sell crypto to your local currency',
      ),
      SActionSheetItem(
        onTap: onConvert,
        icon: const SActionConvertIcon(),
        name: 'Convert',
        description: 'Quickly swap one crypto for another',
      ),
      SActionSheetItem(
        onTap: onDeposit,
        icon: const SActionDepositIcon(),
        name: 'Deposit',
        description: 'Deposit with fiat',
      ),
      SActionSheetItem(
        onTap: onWithdraw,
        icon: const SActionWithdrawIcon(),
        name: 'Withdraw',
        description: 'Withdraw crypto to your credit card',
      ),
      SActionSheetItem(
        onTap: onSend,
        icon: const SActionSendIcon(),
        name: 'Send',
        description: 'Send crypto to another wallet',
      ),
      SActionSheetItem(
        onTap: onReceive,
        icon: const SActionReceiveIcon(),
        name: 'Receive',
        description: 'Receive crypto from another wallet',
      ),
      const SpaceH20(),
    ],
  );
}
