import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_add_cash.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_freeze.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_hide_details.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_settings.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_show_details.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_terminate.dart';
import 'package:simple_kit/simple_kit.dart';

class SimpleCardActionButtons extends StatelessObserverWidget {
  const SimpleCardActionButtons({
    super.key,
    this.isDetailsShown = false,
    this.isFrozen = false,
    this.isTerminateAvailable = true,
    this.isAddCashAvailable = true,
    this.onAddCash,
    this.onShowDetails,
    this.onFreeze,
    this.onSettings,
    this.onTerminate,
  });

  final bool isDetailsShown;
  final bool isFrozen;
  final bool isTerminateAvailable;
  final bool isAddCashAvailable;
  final Function()? onAddCash;
  final Function()? onShowDetails;
  final Function()? onFreeze;
  final Function()? onSettings;
  final Function()? onTerminate;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isFrozen) ...[
              const SizedBox(
                width: 75,
              ),
              CircleActionFreeze(
                isFrozen: isFrozen,
                onTap: () {
                  onFreeze?.call();
                },
              ),
              CircleActionTerminate(
                onTap: () {
                  onTerminate?.call();
                },
                isDisabled: !isTerminateAvailable,
              ),
              const SizedBox(
                width: 75,
              ),
            ]
            else ...[
              CircleActionAddCash(
                onTap: () {
                  onAddCash?.call();
                },
                isDisabled: !isAddCashAvailable,
              ),
              if (isDetailsShown)
                CircleActionHideDetails(
                  onTap: () {
                    onShowDetails?.call();
                  },
                )
              else
                CircleActionShowDetails(
                  onTap: () {
                    onShowDetails?.call();
                  },
                ),
              CircleActionFreeze(
                isFrozen: isFrozen,
                onTap: () {
                  onFreeze?.call();
                },
              ),
              CircleActionSettings(
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
