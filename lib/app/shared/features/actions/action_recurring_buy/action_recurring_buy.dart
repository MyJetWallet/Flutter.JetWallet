import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../helpers/recurring_operation_name.dart';
import '../../../models/currency_model.dart';
import '../../currency_buy/view/curency_buy.dart';
import 'components/action_recurring_buy_item.dart';

void showRecurringBuyAction({
  required BuildContext context,
  required CurrencyModel currency,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const _RecurringActionBottomSheetHeader(
      name: 'Setup recurring buy',
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      _ActionRecurringBuy(
        currency: currency,
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
                child: const SEraseMarketIcon(),
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
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SPaddingH24(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ActionRecurringBuyItem(
                primaryText: recurringBuyName(RecurringBuyType.daily),
                onTap: () => _navigateToCurrencyBuy(context),
              ),
              const SDivider(),
              ActionRecurringBuyItem(
                primaryText: recurringBuyName(RecurringBuyType.weekly),
                onTap: () => _navigateToCurrencyBuy(context),
              ),
              const SDivider(),
              ActionRecurringBuyItem(
                primaryText: recurringBuyName(RecurringBuyType.biWeekly),
                onTap: () => _navigateToCurrencyBuy(context),
              ),
              const SDivider(),
              ActionRecurringBuyItem(
                primaryText: recurringBuyName(RecurringBuyType.monthly),
                onTap: () => _navigateToCurrencyBuy(context),
              ),
              const SpaceH24(),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToCurrencyBuy(BuildContext context) {
    navigatorPushReplacement(
      context,
      CurrencyBuy(
        currency: currency,
        fromCard: false,
      ),
    );
  }
}
