import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/recurring_buys_model.dart';
import '../../../models/currency_model.dart';
import '../../recurring/notifier/recurring_buys_notipod.dart';
import 'components/recurring_buys_item.dart';

void showRecurringBuyAction({
  required BuildContext context,
  required CurrencyModel currency,
  required String total,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: _RecurringActionBottomSheetHeader(
      name: 'Recurring buy $total',
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
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(recurringBuysNotipod);

    return Column(
      children: [
        for (final element in state.recurringBuys) ...[
          if (currency.symbol == element.toAsset)
            RecurringBuysItem(
              recurring: element,
              onTap: (RecurringBuysModel recurring) {
                navigatorPush(
                  context,
                  ShowRecurringInfoAction(
                    recurringItem: element,
                    assetName: currency.description,
                  ),
                );
              },
            ),
        ],
      ],
    );
  }
}
