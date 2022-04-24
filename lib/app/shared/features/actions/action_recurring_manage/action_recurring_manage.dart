import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/recurring_buys_model.dart';
import '../../recurring/helper/recurring_buys_status_name.dart';
import '../../recurring/notifier/recurring_buys_notipod.dart';
import 'components/action_recurring_manage_item.dart';

void showRecurringManageAction({
  required BuildContext context,
  required RecurringBuysModel recurringItem,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const _RecurringManageActionBottomSheetHeader(
      name: 'Manage',
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      _ActionRecurringManage(recurringItem: recurringItem),
    ],
  );
}

class _RecurringManageActionBottomSheetHeader extends HookWidget {
  const _RecurringManageActionBottomSheetHeader({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SPaddingH24(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Baseline(
                baseline: 20.0,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  name,
                  style: sTextH4Style,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const SErasePressedIcon(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionRecurringManage extends HookWidget {
  const _ActionRecurringManage({
    Key? key,
    required this.recurringItem,
  }) : super(key: key);

  final RecurringBuysModel recurringItem;

  @override
  Widget build(BuildContext context) {
    final recurringBuysN = useProvider(recurringBuysNotipod.notifier);

    final _errorImage = Image.asset(
      ellipsisAsset,
      package: 'simple_kit',
    );

    return Column(
      children: [
        SPaddingH24(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recurringItem.status != RecurringBuysStatus.paused)
                ActionRecurringManageItem(
                  icon: const SPauseIcon(),
                  primaryText: 'Pause',
                  onTap: () {
                    recurringBuysN.switchRecurringStatus(
                      isEnable: false,
                      instructionId: recurringItem.id!,
                    );
                    Navigator.of(context)
                      ..pop()
                      ..pop()
                      ..pop();
                    // recurringItem.status = RecurringBuysStatus.paused;
                  },
                ),
              if (recurringItem.status == RecurringBuysStatus.paused)
                ActionRecurringManageItem(
                  icon: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 4,
                    ),
                    child: const SStartIcon(),
                  ),
                  primaryText: 'Start',
                  onTap: () {
                    recurringBuysN.switchRecurringStatus(
                      isEnable: true,
                      instructionId: recurringItem.id!,
                    );
                    Navigator.of(context)
                      ..pop()
                      ..pop()
                      ..pop();
                    // recurringItem.status = RecurringBuysStatus.active;
                  },
                ),
              const SDivider(),
              ActionRecurringManageItem(
                icon: const SDeleteManageIcon(),
                primaryText: 'Delete',
                onTap: () => sShowAlertPopup(
                  context,
                  willPopScope: false,
                  image: _errorImage,
                  primaryText: 'Delete Recurring buy?',
                  secondaryText: 'Are you sure you want to delete '
                      'your Recurring buy?',
                  primaryButtonName: 'Delete',
                  onPrimaryButtonTap: () {
                    recurringBuysN.removeRecurringBuy(recurringItem.id!);
                    Navigator.of(context)
                      ..pop()
                      ..pop()
                      ..pop()
                      ..pop();
                  },
                  primaryButtonType: SButtonType.primary3,
                  secondaryButtonName: 'Cancel',
                  onSecondaryButtonTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SpaceH24(),
            ],
          ),
        ),
      ],
    );
  }
}
