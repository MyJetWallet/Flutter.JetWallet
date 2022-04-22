import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/signal_r/model/recurring_buys_model.dart';
import '../../../../../../shared/constants.dart';
import '../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../recurring/helper/recurring_buys_operation_name.dart';
import '../../../recurring/helper/recurring_buys_status_name.dart';
import '../../../recurring/notifier/recurring_buys_notipod.dart';

class RecurringBuysItem extends HookWidget {
  const RecurringBuysItem({
    Key? key,
    this.removeDivider = false,
    required this.recurring,
    required this.onTap,
  }) : super(key: key);

  final bool removeDivider;
  final RecurringBuysModel recurring;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final notifier = useProvider(recurringBuysNotipod.notifier);
    final baseCurrency = useProvider(baseCurrencyPod);

    return InkWell(
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: 88.0,
          child: Column(
            children: [
              const SpaceH22(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (recurring.status == RecurringBuysStatus.active)
                    SvgPicture.asset(
                      recurringBuyAsset,
                    ),
                  if (recurring.status == RecurringBuysStatus.paused)
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
                              recurring.scheduleType,
                            ),
                            style: sSubtitle2Style.copyWith(
                              color: recurring.status ==
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
                            '${recurring.fromAmount} ${recurring.toAsset}',
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
                            asset: recurring.toAsset,
                            amount: recurring.fromAmount!,
                          ),
                          style: sSubtitle2Style.copyWith(
                            color: recurring.status ==
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
                              '${recurring.totalToAmount}',
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
              if (!removeDivider)
              const SDivider(
                width: double.infinity,
              )
            ],
          ),
        ),
      ),
    );
  }
}
