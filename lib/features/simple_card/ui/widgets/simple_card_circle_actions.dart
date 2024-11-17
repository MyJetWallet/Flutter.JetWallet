import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

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
        child: ActionPannel(
          actionButtons: [
            if (isFrozen) ...[
              SActionButton(
                onTap: () {
                  onFreeze?.call();
                },
                lable: isFrozen ? intl.simple_card_unfreeze : intl.simple_card_freeze,
                icon: Assets.svg.medium.arrowUp.simpleSvg(
                  color: SColorsLight().white,
                ),
              )
            ] else ...[
              SActionButton(
                lable: intl.wallet_add_cash,
                icon: Assets.svg.medium.addCash.simpleSvg(
                  color: SColorsLight().white,
                ),
                onTap: () {
                  onAddCash?.call();
                },
              ),
              SActionButton(
                lable: intl.wallet_withdraw,
                icon: Assets.svg.medium.withdrawal.simpleSvg(
                  color: SColorsLight().white,
                ),
                state: isWithdrawAvailable ? ActionButtonState.defaylt : ActionButtonState.disabled,
                onTap: () {
                  onWithdraw?.call();
                },
              ),
              SActionButton(
                lable: intl.simple_card_actions_settings,
                icon: Assets.svg.medium.settings.simpleSvg(
                  color: SColorsLight().white,
                ),
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
