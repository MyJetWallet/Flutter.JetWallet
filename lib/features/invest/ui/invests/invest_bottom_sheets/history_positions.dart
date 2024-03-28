import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_positions_store.dart';
import 'package:jetwallet/features/invest/ui/invests/above_list_line.dart';
import 'package:jetwallet/features/invest/ui/invests/secondary_switch.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_history_list.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_history_pending_list.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_history_summary_list.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

import '../../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../../utils/enum.dart';
import '../../../../../utils/helpers/currency_from.dart';
import '../../../helpers/invest_period_info.dart';
import '../../../stores/dashboard/invest_dashboard_store.dart';
import '../../widgets/invest_period_bottom_sheet.dart';
import '../main_invest_block.dart';

class HistoryInvestList extends StatelessObserverWidget {
  const HistoryInvestList();

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final investPositionsStore = getIt.get<InvestPositionsStore>();
    final investStore = getIt.get<InvestDashboardStore>();
    final currencies = sSignalRModules.currenciesList;
    final currency = currencyFrom(currencies, 'USDT');

    return Observer(
      builder: (BuildContext context) {
        return Column(
          children: [
            const SpaceH12(),
            Observer(
              builder: (BuildContext context) {
                if (investPositionsStore.historyTab == 1) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          Observer(
                            builder: (BuildContext context) {
                              return SecondarySwitch(
                                onChangeTab: investPositionsStore.setHistoryTab,
                                activeTab: investPositionsStore.historyTab,
                                fullWidth: false,
                                tabs: [
                                  intl.invest_history_tab_invest,
                                  intl.invest_history_tab_pending,
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      MainInvestBlock(
                        pending: Decimal.zero,
                        amount: investPositionsStore.totalAmount,
                        balance: investPositionsStore.totalProfit,
                        percent: investPositionsStore.totalProfitPercent,
                        onShare: () {},
                        currency: currency,
                        showPercent: false,
                        showAmount: false,
                        showShare: false,
                        showBalance: false,
                        title: intl.invest_history_pending,
                      ),
                      const SpaceH4(),
                      AboveListLine(
                        showDivider: false,
                        mainColumn: intl.invest_list_instrument,
                        secondaryColumn: '${intl.invest_list_amount} (${currency.symbol})',
                        lastColumn: intl.invest_price,
                        onCheckboxTap: investPositionsStore.setIsHistoryGrouped,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 304,
                        child: const InvestHistoryPendingList(),
                      ),
                    ],
                  );
                }

                if (investPositionsStore.isHistoryGrouped) {
                  return const InvestHistorySummaryList();
                }

                return Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            showInvestPeriodBottomSheet(
                              context,
                              (InvestHistoryPeriod value) {
                                investStore.updatePeriod(value);
                                investPositionsStore.requestInvestHistorySummary(false);
                              },
                              investStore.period,
                            );
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          child: Row(
                            children: [
                              Assets.svg.invest.investCalendar.simpleSvg(
                                width: 16,
                                height: 16,
                                color: colors.black,
                              ),
                              const SpaceW4(),
                              Text(
                                '${getDaysByPeriod(investStore.period)} ${intl.invest_period_days}',
                                style: STStyles.body1InvestSM,
                              ),
                              const SpaceW4(),
                              Assets.svg.invest.investArrow.simpleSvg(
                                width: 14,
                                height: 14,
                                color: colors.black,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Observer(
                          builder: (BuildContext context) {
                            return SecondarySwitch(
                              onChangeTab: investPositionsStore.setHistoryTab,
                              activeTab: investPositionsStore.historyTab,
                              fullWidth: false,
                              tabs: [
                                intl.invest_history_tab_invest,
                                intl.invest_history_tab_pending,
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    MainInvestBlock(
                      pending: Decimal.zero,
                      amount: investPositionsStore.totalAmount,
                      balance: investPositionsStore.totalProfit,
                      percent: investPositionsStore.totalProfitPercent,
                      onShare: () {},
                      currency: currency,
                      title: intl.invest_history_invest,
                    ),
                    const SpaceH4(),
                    if (investPositionsStore.historyTab == 0)
                      AboveListLine(
                        mainColumn: intl.invest_group,
                        secondaryColumn: '${intl.invest_list_amount} (${currency.symbol})',
                        lastColumn: '${intl.invest_list_pl} (${currency.symbol})',
                        withCheckbox: true,
                        checked: investPositionsStore.isHistoryGrouped,
                        onCheckboxTap: investPositionsStore.setIsHistoryGrouped,
                        sortState: investPositionsStore.historySortState,
                        onSortTap: investPositionsStore.setHistorySort,
                        showDivider: false,
                      )
                    else
                      AboveListLine(
                        mainColumn: intl.invest_list_instrument,
                        secondaryColumn: '${intl.invest_list_amount} (${currency.symbol})',
                        lastColumn: intl.invest_price,
                        onCheckboxTap: investPositionsStore.setIsHistoryGrouped,
                        showDivider: false,
                      ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 304,
                      child: const InvestHistoryList(),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
