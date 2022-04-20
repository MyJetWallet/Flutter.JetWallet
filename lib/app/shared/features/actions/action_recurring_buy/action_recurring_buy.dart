import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/constants.dart';
import '../../../models/currency_model.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../recurring/helper/recurring_buys_operation_name.dart';
import '../../recurring/helper/recurring_buys_status_name.dart';
import '../../recurring/notifier/recurring_buys_notipod.dart';

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
    final notifier = useProvider(recurringBuysNotipod.notifier);
    final baseCurrency = useProvider(baseCurrencyPod);

    final colors = useProvider(sColorPod);

    return Column(
      children: [
        for (final element in state.recurringBuys) ...[
          if (currency.symbol == element.toAsset)
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {},
              child: SPaddingH24(
                child: SizedBox(
                  height: 88.0,
                  child: Column(
                    children: [
                      const SpaceH22(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (element.status == RecurringBuysStatus.active)
                            SvgPicture.asset(
                              recurringBuyAsset,
                            ),
                          if (element.status == RecurringBuysStatus.paused)
                            const SPausedIcon(),
                          const SpaceW20(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Baseline(
                                  baseline: 18.0,
                                  baselineType: TextBaseline.alphabetic,
                                  child: Text(
                                    recurringBuysOperationName(
                                      element.scheduleType,
                                    ),
                                    style: sSubtitle2Style.copyWith(
                                      color: element.status ==
                                              RecurringBuysStatus.active
                                          ? colors.black
                                          : colors.grey3,
                                    ),
                                  ),
                                ),
                                Baseline(
                                  baseline: 18.0,
                                  baselineType: TextBaseline.alphabetic,
                                  child: Text(
                                    '${element.fromAmount} ${element.toAsset}',
                                    style: sBodyText2Style.copyWith(
                                      color: colors.grey3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SpaceW10(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Baseline(
                                baseline: 18.0,
                                baselineType: TextBaseline.alphabetic,
                                child: Text(
                                  notifier.price(
                                    asset: element.toAsset,
                                    amount: element.fromAmount!,
                                  ),
                                  style: sSubtitle2Style.copyWith(
                                    color: element.status ==
                                            RecurringBuysStatus.active
                                        ? colors.black
                                        : colors.grey3,
                                  ),
                                ),
                              ),
                              Baseline(
                                baseline: 18.0,
                                baselineType: TextBaseline.alphabetic,
                                child: Text(
                                  'Total ${notifier.price(
                                    asset: baseCurrency.symbol,
                                    amount: double.parse(
                                      '${element.totalToAmount}',
                                    ),
                                  )}',
                                  style: sBodyText2Style.copyWith(
                                    color: colors.grey3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      const SDivider(
                        width: double.infinity,
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
