import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_positions_store.dart';
import 'package:jetwallet/features/invest/ui/dashboard/invest_header.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_button.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_history_list.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_history_pending_list.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_market_watch_bottom_sheet.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';

import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../utils/helpers/currency_from.dart';
import '../helpers/invest_period_info.dart';
import 'invests/above_list_line.dart';
import 'invests/main_invest_block.dart';
import 'invests/secondary_switch.dart';

@RoutePage(name: 'InvestHistoryPageRouter')
class InvestHistoryScreen extends StatefulObserverWidget {
  const InvestHistoryScreen({
    super.key,
    required this.instrument,
  });

  final InvestInstrumentModel instrument;

  @override
  State<InvestHistoryScreen> createState() => _InvestHistoryScreenState();
}

class _InvestHistoryScreenState extends State<InvestHistoryScreen> {bool canTapShare = true;
  late ScrollController controller;
  late WebViewController controllerWeb;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;
    final colors = sKit.colors;
    final currency = currencyFrom(currencies, 'USDT');

    final investStore = getIt.get<InvestDashboardStore>();
    final investPositionsStore = getIt.get<InvestPositionsStore>();

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: InvestHeader(
          currency: currency,
          withBackBlock: true,
          onBackButton: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 98.0,
        child: Column(
          children: [
            const SpaceH20(),
            SPaddingH24(
              child: Row(
                children: [
                  Expanded(
                    child: SIButton(
                      activeColor: colors.blue,
                      activeNameColor: colors.white,
                      inactiveColor: colors.grey4,
                      inactiveNameColor: colors.grey2,
                      active: true,
                      icon: const SIPlusIcon(
                        width: 20,
                        height: 20,
                      ),
                      name: intl.invest_list_new_invest,
                      onTap: () {
                        investStore.setActiveSection('S0');
                        showInvestMarketWatchBottomSheet(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SpaceH34(),
          ],
        ),
      ),
      child: SPaddingH24(
        child: Observer(
          builder: (BuildContext context) {
            final summary = investPositionsStore.allSummary.where(
              (element) => element.symbol == widget.instrument.symbol,
            ).toList();

            return Column(
              children: [
                const SpaceH12(),
                Observer(
                  builder: (BuildContext context) {
                    if (investPositionsStore.historyTab == 1) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 56,
                            width: MediaQuery.of(context).size.width - 48,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 56,
                                  child: Center(
                                    child: Text(
                                      intl.invest_history_pending,
                                      style: sTextH2InvestStyle.copyWith(
                                        color: colors.black,
                                      ),
                                    ),
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
                          ),
                          const SpaceH4(),
                          AboveListLine(
                            mainColumn: intl.invest_list_instrument,
                            secondaryColumn: '${intl.invest_list_amount} (${currency.symbol})',
                            lastColumn: intl.invest_price,
                            onCheckboxTap: investPositionsStore.setIsHistoryGrouped,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height - 330,
                            child: InvestHistoryPendingList(
                              instrument: widget.instrument.symbol,
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  SICalendarIcon(
                                    width: 16,
                                    height: 16,
                                    color: colors.black,
                                  ),
                                  const SpaceW4(),
                                  Text(
                                    '${getDaysByPeriod(investStore.period)} ${intl.invest_period_days}',
                                    style: sBody1InvestSMStyle,
                                  ),
                                  const SpaceW4(),
                                  SIArrowIcon(
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
                          amount: summary[0].amount ?? Decimal.zero,
                          balance: summary[0].amountPl ?? Decimal.zero,
                          percent: summary[0].percentPl ?? Decimal.zero,
                          onShare: () {},
                          currency: currency,
                          title: intl.invest_history_invest,
                        ),
                        const SpaceH4(),
                        AboveListLine(
                          mainColumn: intl.invest_list_instrument,
                          secondaryColumn: '${intl.invest_list_amount} (${currency.symbol})',
                          lastColumn: intl.invest_price,
                          onCheckboxTap: investPositionsStore.setIsHistoryGrouped,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 330,
                          child: InvestHistoryList(
                            instrument: widget.instrument.symbol,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
