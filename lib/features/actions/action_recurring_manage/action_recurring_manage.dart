import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/actions/action_recurring_manage/widgets/action_recurring_manage_item.dart';
import 'package:jetwallet/features/reccurring/helper/recurring_buys_operation_name.dart';
import 'package:jetwallet/features/reccurring/store/recurring_buys_store.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_model.dart';

void showRecurringManageAction({
  required BuildContext context,
  required String assetName,
  required String sellCurrencyAmount,
  required RecurringBuysModel recurringItem,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: _RecurringManageActionBottomSheetHeader(
      name: intl.actionRecurringManage_manage,
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      _ActionRecurringManage(
        assetName: assetName,
        sellCurrencyAmount: sellCurrencyAmount,
        recurringItem: recurringItem,
      ),
    ],
  );
}

class _RecurringManageActionBottomSheetHeader extends StatelessWidget {
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

class _ActionRecurringManage extends StatelessObserverWidget {
  const _ActionRecurringManage({
    Key? key,
    required this.assetName,
    required this.sellCurrencyAmount,
    required this.recurringItem,
  }) : super(key: key);

  final String assetName;
  final String sellCurrencyAmount;
  final RecurringBuysModel recurringItem;

  @override
  Widget build(BuildContext context) {
    final recurringBuysN = getIt.get<RecurringBuysStore>();

    final colors = sKit.colors;

    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceH24(),
            if (recurringItem.status != RecurringBuysStatus.paused)
              ActionRecurringManageItem(
                icon: const SPauseIcon(),
                primaryText: intl.actionRecurringManage_pause,
                color: colors.grey5,
                onTap: () async {
                  await recurringBuysN.switchRecurringStatus(
                    isEnable: false,
                    instructionId: recurringItem.id!,
                  );
                  Navigator.of(context)
                    ..pop()
                    ..pop();
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
                primaryText: intl.actionRecurringManage_start,
                color: colors.grey5,
                onTap: () {
                  recurringBuysN.switchRecurringStatus(
                    isEnable: true,
                    instructionId: recurringItem.id!,
                  );
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                },
              ),
            const SPaddingH24(
              child: SDivider(),
            ),
            ActionRecurringManageItem(
              icon: const SDeleteManageIcon(),
              primaryText: intl.actionRecurringManage_delete,
              color: colors.grey5,
              onTap: () {

                sShowAlertPopup(
                  context,
                  willPopScope: false,
                  primaryText:
                      '${intl.actionRecurringManage_manageItemPrimaryText}?',
                  secondaryText:
                      '${intl.actionRecurringManage_manageItemSecondaryText}?',
                  primaryButtonName: intl.actionRecurringManage_delete,
                  onPrimaryButtonTap: () {
                    recurringBuysN.removeRecurringBuy(recurringItem.id!);
                    Navigator.of(context)
                      ..pop()
                      ..pop()
                      ..pop();
                  },
                  primaryButtonType: SButtonType.primary3,
                  secondaryButtonName: intl.actionRecurringManage_cancel,
                  onSecondaryButtonTap: () {
                    Navigator.pop(context);
                  },
                );
              },
            ),
            const SpaceH24(),
          ],
        ),
      ],
    );
  }
}
