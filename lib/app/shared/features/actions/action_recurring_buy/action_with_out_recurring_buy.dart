import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/swap/model/get_quote/get_quote_request_model.dart';

import '../../recurring/helper/recurring_buys_operation_name.dart';
import 'components/without_recurring_buy_item.dart';

void showActionWithOutRecurringBuy({
  bool showOneTimePurchase = false,
  RecurringBuysType? currentType,
  void Function()? then,
  required BuildContext context,
  required String title,
  required void Function(RecurringBuysType) onItemTap,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: _RecurringActionBottomSheetHeader(
      name: title,
    ),
    horizontalPinnedPadding: 0.0,
    children: [
      _ActionRecurringBuy(
        currentType: currentType,
        onItemTap: onItemTap,
        showOneTimePurchase: showOneTimePurchase,
      )
    ],
  );
}

class _RecurringActionBottomSheetHeader extends HookWidget {
  const _RecurringActionBottomSheetHeader({
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

class _ActionRecurringBuy extends HookWidget {
  const _ActionRecurringBuy({
    Key? key,
    this.currentType,
    required this.showOneTimePurchase,
    required this.onItemTap,
  }) : super(key: key);

  final bool showOneTimePurchase;
  final RecurringBuysType? currentType;
  final void Function(RecurringBuysType) onItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showOneTimePurchase) ...[
              WithOutRecurringBuysItem(
                primaryText: recurringBuysOperationName(
                  RecurringBuysType.oneTimePurchase,
                ),
                selected: currentType == RecurringBuysType.oneTimePurchase,
                onTap: () {
                  onItemTap(RecurringBuysType.oneTimePurchase);
                },
              ),
              const SPaddingH24(
                child: SDivider(),
              ),
            ],
            WithOutRecurringBuysItem(
              primaryText: recurringBuysOperationName(
                RecurringBuysType.daily,
              ),
              selected: currentType == RecurringBuysType.daily,
              onTap: () {
                onItemTap(RecurringBuysType.daily);
              },
            ),
            const SPaddingH24(
              child: SDivider(),
            ),
            WithOutRecurringBuysItem(
              primaryText: recurringBuysOperationName(RecurringBuysType.weekly),
              selected: currentType == RecurringBuysType.weekly,
              onTap: () {
                onItemTap(RecurringBuysType.weekly);
              },
            ),
            const SPaddingH24(
              child: SDivider(),
            ),
            WithOutRecurringBuysItem(
              primaryText:
                  recurringBuysOperationName(RecurringBuysType.biWeekly),
              selected: currentType == RecurringBuysType.biWeekly,
              onTap: () {
                onItemTap(RecurringBuysType.biWeekly);
              },
            ),
            const SPaddingH24(
              child: SDivider(),
            ),
            WithOutRecurringBuysItem(
              primaryText:
                  recurringBuysOperationName(RecurringBuysType.monthly),
              selected: currentType == RecurringBuysType.monthly,
              onTap: () {
                onItemTap(RecurringBuysType.monthly);
              },
            ),
            const SpaceH40(),
          ],
        ),
      ],
    );
  }
}
