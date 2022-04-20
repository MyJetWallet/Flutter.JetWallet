import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

import 'components/action_recurring_manage_item.dart';

void showRecurringManageAction({
  required BuildContext context,
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
      const _ActionRecurringManage(),
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
                child: const SEraseMarketIcon(),
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SPaddingH24(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ActionRecurringManageItem(
                icon: const SPauseIcon(),
                primaryText: 'Pause',
                onTap: () => {},
              ),
              const SDivider(),
              ActionRecurringManageItem(
                icon: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 4,
                  ),
                  child: SStartIcon(),
                ),
                primaryText: 'Start',
                onTap: () => {},
              ),
              const SDivider(),
              ActionRecurringManageItem(
                icon: const SDeleteManageIcon(),
                primaryText: 'Delete',
                onTap: () => {},
              ),
              const SpaceH24(),
            ],
          ),
        ),
      ],
    );
  }
}
