import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/reccurring/helper/recurring_buys_operation_name.dart';
import 'package:jetwallet/features/reccurring/store/recurring_buys_store.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_model.dart';

class RecurringBuysItem extends StatelessObserverWidget {
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
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;
    final currencies = sSignalRModules.currenciesList;

    final sellCurrency = currencyFrom(
      currencies,
      recurring.fromAsset,
    );

    return InkWell(
      highlightColor: colors.grey5,
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
                    const SRecurringBuysIcon(),
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
                            '${recurring.toAsset} ${recurringBuysOperationName(
                              recurring.scheduleType,
                            )}',
                            style: sSubtitle2Style.copyWith(
                              color:
                                  recurring.status == RecurringBuysStatus.active
                                      ? colors.black
                                      : colors.grey3,
                            ),
                          ),
                        ),
                        Baseline(
                          baseline: 18.0,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            _setTitle(recurring, context),
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
                          '${sellCurrency.prefixSymbol ?? ''}'
                          '${recurring.fromAmount} '
                          '${sellCurrency.prefixSymbol != null ? '' : sellCurrency.symbol}',
                          style: sSubtitle2Style.copyWith(
                            color:
                                recurring.status == RecurringBuysStatus.active
                                    ? colors.black
                                    : colors.grey3,
                          ),
                        ),
                      ),
                      Baseline(
                        baseline: 18.0,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          '${intl.recurringBuysItem_total} '
                          '${getIt.get<RecurringBuysStore>().price(
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
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _setTitle(RecurringBuysModel recurring, BuildContext context) {
    return recurring.status == RecurringBuysStatus.paused
        ? intl.recurringBuysItem_paused
        : '${recurring.lastToAmount} ${recurring.toAsset}';
  }
}
