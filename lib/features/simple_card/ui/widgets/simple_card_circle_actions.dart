import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_button.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_freeze.dart';
import 'package:simple_kit/simple_kit.dart';

class SimpleCardActionButtons extends StatelessObserverWidget {
  const SimpleCardActionButtons({
    super.key,
    this.isDetailsShown = false,
    this.isFrozen = false,
    this.isTerminateAvailable = true,
    this.isAddCashAvailable = true,
    this.isWithdrawAvailable = true,
    this.onAddCash,
    this.onShowDetails,
    this.onFreeze,
    this.onSettings,
    this.onTerminate,
    this.onWithdraw,
  });

  final bool isDetailsShown;
  final bool isFrozen;
  final bool isTerminateAvailable;
  final bool isAddCashAvailable;
  final bool isWithdrawAvailable;
  final Function()? onAddCash;
  final Function()? onShowDetails;
  final Function()? onFreeze;
  final Function()? onSettings;
  final Function()? onTerminate;
  final Function()? onWithdraw;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isFrozen) ...[
              CircleActionFreeze(
                isFrozen: isFrozen,
                onTap: () {
                  onFreeze?.call();
                },
              ),
            ] else ...[
              CircleActionButton(
                text: intl.wallet_add_cash,
                type: CircleButtonType.addCash,
                onTap: () {
                  onAddCash?.call();
                },
              ),
              CircleActionButton(
                text: intl.wallet_withdraw,
                type: CircleButtonType.withdraw,
                isDisabled: !isWithdrawAvailable,
                onTap: () {
                  onWithdraw?.call();
                },
              ),
              CircleActionButton(
                text: intl.simple_card_actions_settings,
                type: CircleButtonType.settings,
                onTap: () {
                  onSettings?.call();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
