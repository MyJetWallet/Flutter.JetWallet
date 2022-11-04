import 'package:flutter/material.dart';
import 'package:jetwallet/features/actions/action_recurring_buy/widgets/without_recurring_buy_item.dart';
import 'package:jetwallet/features/reccurring/helper/recurring_buys_operation_name.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';

void showActionWithoutRecurringBuy({
  bool showOneTimePurchase = false,
  RecurringBuysType? currentType,
  void Function(dynamic)? then,
  VoidCallback? onDissmis,
  required BuildContext context,
  required String title,
  required void Function(RecurringBuysType) onItemTap,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: _RecurringActionBottomSheetHeader(
      onDissmis: onDissmis,
      name: title,
    ),
    then: then,
    horizontalPinnedPadding: 0.0,
    children: [
      _ActionRecurringBuy(
        currentType: currentType,
        onItemTap: onItemTap,
        showOneTimePurchase: showOneTimePurchase,
      ),
    ],
    onDissmis: onDissmis,
  );
}

class _RecurringActionBottomSheetHeader extends StatelessWidget {
  const _RecurringActionBottomSheetHeader({
    Key? key,
    required this.name,
    this.onDissmis,
  }) : super(key: key);
  final VoidCallback? onDissmis;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SPaddingH24(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Baseline(
                baseline: 20.0,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  name,
                  maxLines: 2,
                  style: sTextH4Style,
                ),
              ),
              GestureDetector(
                onTap: () => {Navigator.pop(context), onDissmis?.call()},
                child: const SErasePressedIcon(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionRecurringBuy extends StatelessWidget {
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
              WithoutRecurringBuysItem(
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
            WithoutRecurringBuysItem(
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
            WithoutRecurringBuysItem(
              primaryText: recurringBuysOperationName(
                RecurringBuysType.weekly,
              ),
              selected: currentType == RecurringBuysType.weekly,
              onTap: () {
                onItemTap(RecurringBuysType.weekly);
              },
            ),
            const SPaddingH24(
              child: SDivider(),
            ),
            WithoutRecurringBuysItem(
              primaryText: recurringBuysOperationName(
                RecurringBuysType.biWeekly,
              ),
              selected: currentType == RecurringBuysType.biWeekly,
              onTap: () {
                onItemTap(RecurringBuysType.biWeekly);
              },
            ),
            const SPaddingH24(
              child: SDivider(),
            ),
            WithoutRecurringBuysItem(
              primaryText: recurringBuysOperationName(
                RecurringBuysType.monthly,
              ),
              selected: currentType == RecurringBuysType.monthly,
              onTap: () {
                onItemTap(RecurringBuysType.monthly);
              },
            ),
            const SpaceH24(),
          ],
        ),
      ],
    );
  }
}
