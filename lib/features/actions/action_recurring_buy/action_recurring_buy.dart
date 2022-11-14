import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/actions/action_recurring_buy/widgets/recurring_buys_item.dart';
import 'package:jetwallet/features/reccurring/store/recurring_buys_store.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_model.dart';

void showRecurringBuyAction({
  required BuildContext context,
  required CurrencyModel currency,
  required String total,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: _RecurringActionBottomSheetHeader(
      name: '${intl.recurringBuysName_active} $total',
    ),
    horizontalPinnedPadding: 0.0,
    children: [
      _ActionRecurringBuy(
        currency: currency,
      ),
    ],
  );
}

class _RecurringActionBottomSheetHeader extends StatelessWidget {
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
                  maxLines: 2,
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

class _ActionRecurringBuy extends StatelessObserverWidget {
  const _ActionRecurringBuy({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final state = getIt.get<RecurringBuysStore>();

    final recurring = <RecurringBuysModel>[];

    for (final element in state.recurringBuysFiltred) {
      if (currency.symbol == element.toAsset) {
        recurring.add(element);
      }
    }

    return Column(
      children: [
        for (final element in recurring) ...[
          RecurringBuysItem(
            recurring: element,
            removeDivider: element == recurring.last,
            onTap: () {
              Navigator.pop(context);

              sRouter.push(
                ShowRecurringInfoActionRouter(
                  recurringItem: element,
                  assetName: currency.description,
                ),
              );
            },
          ),
        ],
        const SpaceH24(),
      ],
    );
  }
}
