import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_new_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_positions_store.dart';
import 'package:jetwallet/features/invest/ui/dashboard/invest_header.dart';
import 'package:jetwallet/features/invest/ui/invests/symbol_info_without_chart.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_alert_bottom_sheet.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_button.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_market_watch_bottom_sheet.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/public/invest/simple_invest_chart_candles.dart';
import 'package:simple_kit/modules/icons/custom/public/invest/simple_invest_chart_line.dart';
import 'package:simple_kit/modules/icons/custom/public/invest/simple_invest_close.dart';
import 'package:simple_kit/modules/icons/custom/public/invest/simple_invest_plus.dart';
import 'package:simple_kit/modules/shared/page_frames/simple_page_frame.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';

import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../utils/formatting/base/volume_format.dart';
import '../../../utils/helpers/currency_from.dart';
import 'chart/invest_chart.dart';
import 'invests/data_line.dart';
import 'invests/invest_bottom_sheets/active_positions.dart';
import 'invests/invest_bottom_sheets/pending_positions.dart';
import 'invests/secondary_switch.dart';

@RoutePage(name: 'InstrumentPageRouter')
class InstrumentScreen extends StatefulObserverWidget {
  const InstrumentScreen({
    super.key,
    required this.instrument,
  });

  final InvestInstrumentModel instrument;

  @override
  State<InstrumentScreen> createState() => _InstrumentScreenState();
}

class _InstrumentScreenState extends State<InstrumentScreen> {
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;
    final investNewStore = getIt.get<InvestNewStore>();
    final investStore = getIt.get<InvestDashboardStore>();
    final investPositionsStore = getIt.get<InvestPositionsStore>();

    final colors = sKit.colors;
    final currency = currencyFrom(currencies, 'USDT');

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      loading: investPositionsStore.loader,
      header: SPaddingH24(
        child: InvestHeader(
          currency: currency,
          withBackBlock: true,
          onBackButton: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: Material(
        color: colors.white,
        child: Observer(
          builder: (BuildContext context) {
            if (investPositionsStore.activeInstrumentTab == 0) {
              return SizedBox(
                height: 98.0,
                child: Column(
                  children: [
                    const SpaceH20(),
                    SPaddingH24(
                      child: Row(
                        children: [
                          if (investPositionsStore.activeList.isNotEmpty) ...[
                            Expanded(
                              child: SIButton(
                                activeColor: colors.black,
                                activeNameColor: colors.white,
                                inactiveColor: colors.grey2,
                                inactiveNameColor: colors.grey4,
                                active: true,
                                icon: const SICloseIcon(
                                  width: 20,
                                  height: 20,
                                ),
                                name: intl.invest_list_close_all,
                                onTap: () {
                                  showInvestInfoBottomSheet(
                                    context: context,
                                    type: 'info',
                                    onPrimaryButtonTap: () => Navigator.pop(context),
                                    onSecondaryButtonTap: () {
                                      Navigator.pop(context);
                                      showInvestInfoBottomSheet(
                                        context: context,
                                        type: 'pending',
                                        onPrimaryButtonTap: () => Navigator.pop(context),
                                        primaryButtonName: intl.invest_alert_got_it,
                                        title: intl.invest_alert_in_progress,
                                        subtitle: intl.invest_alert_in_progress_description,
                                      );
                                      investPositionsStore.closeAllActive(context, widget.instrument.symbol);
                                    },
                                    primaryButtonName: intl.invest_alert_cancel,
                                    secondaryButtonName: intl.invest_alert_close_all,
                                    bottomWidget: DataLine(
                                      mainText: intl.invest_alert_close_all_profit,
                                      secondaryText: volumeFormat(
                                        decimal: investStore.totalProfit,
                                        accuracy: 2,
                                        symbol: currency.symbol,
                                      ),
                                      secondaryColor:
                                      investStore.totalProfit >= Decimal.zero
                                          ? colors.green
                                          : colors.red,
                                    ),
                                    title: intl.invest_alert_close_all_title,
                                    subtitle: intl.invest_alert_close_all_subtitle,
                                  );
                                },
                              ),
                            ),
                            const SpaceW10(),
                          ],
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
                                sRouter.push(
                                  NewInvestPageRouter(instrument: widget.instrument),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpaceH34(),
                  ],
                ),
              );
            }

            return SizedBox(
              height: 98.0,
              child: Column(
                children: [
                  const SpaceH20(),
                  SPaddingH24(
                    child: Row(
                      children: [
                        if (investPositionsStore.pendingList.isNotEmpty) ...[
                          Expanded(
                            child: SIButton(
                              activeColor: colors.black,
                              activeNameColor: colors.white,
                              inactiveColor: colors.grey2,
                              inactiveNameColor: colors.grey4,
                              active: true,
                              icon: const SICloseIcon(
                                width: 20,
                                height: 20,
                              ),
                              name: intl.invest_list_delete_all,
                              onTap: () {
                                showInvestInfoBottomSheet(
                                  context: context,
                                  type: 'info',
                                  onPrimaryButtonTap: () => Navigator.pop(context),
                                  onSecondaryButtonTap: () {
                                    Navigator.pop(context);
                                    showInvestInfoBottomSheet(
                                      context: context,
                                      type: 'pending',
                                      onPrimaryButtonTap: () => Navigator.pop(context),
                                      primaryButtonName: intl.invest_alert_got_it,
                                      title: intl.invest_alert_in_progress,
                                      subtitle: intl.invest_alert_in_progress_description,
                                    );
                                    investPositionsStore.cancelAllPending(context, widget.instrument.symbol);
                                  },
                                  primaryButtonName: intl.invest_alert_cancel,
                                  secondaryButtonName: intl.invest_alert_delete_all,
                                  title: intl.invest_alert_delete_all_title,
                                  subtitle: intl.invest_alert_delete_all_subtitle,
                                );
                              },
                            ),
                          ),
                          const SpaceW10(),
                        ],
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
                              sRouter.push(
                                NewInvestPageRouter(instrument: widget.instrument),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpaceH34(),
                ],
              ),
            );
          },
        ),
      ),
      child: SPaddingH24(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SymbolInfoWithoutChart(
              currency: currency,
              price: investStore.getPriceBySymbol(widget.instrument.symbol ?? ''),
              instrument: widget.instrument,
              onTap: () {
                investStore.setActiveSection('S0');
                showInvestMarketWatchBottomSheet(context);
              },
            ),
            Row(
              children: [
                Observer(
                  builder: (BuildContext context) {
                    return SecondarySwitch(
                      onChangeTab: (value) {
                        investNewStore.setChartInterval(value);
                      },
                      activeTab: investNewStore.chartInterval,
                      fullWidth: false,
                      fromRight: false,
                      tabs: const [
                        '15m',
                        '1h',
                        '4h',
                        '1d',
                      ],
                    );
                  },
                ),
                const Spacer(),
                Observer(
                  builder: (BuildContext context) {
                    return SecondarySwitch(
                      onChangeTab: (value) {
                        investNewStore.setChartType(value);
                      },
                      activeTab: investNewStore.chartType,
                      fullWidth: false,
                      fromRight: false,
                      tabs: const [],
                      tabsAssets: [
                        SIChartLineIcon(
                          width: 16,
                          height: 16,
                          color: investNewStore.chartType == 0 ? colors.black : colors.grey2,
                        ),
                        SIChartCandlesIcon(
                          width: 16,
                          height: 16,
                          color: investNewStore.chartType == 1 ? colors.black : colors.grey2,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SpaceH8(),
            Observer(
              builder: (BuildContext context) {
                return InvestChart(
                  instrument: widget.instrument,
                  chartInterval: investNewStore.getChartInterval(),
                  chartType: investNewStore.getChartType(),
                  width: '${MediaQuery.of(context).size.width - 48}',
                  height: '${MediaQuery.of(context).size.height - 575}',
                );
              },
            ),
            const SpaceH16(),
            SizedBox(
              height: 262,
              child: ListView(
                controller: controller,
                padding: EdgeInsets.zero,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          SecondarySwitch(
                            onChangeTab: investPositionsStore.setActiveInstrumentTab,
                            activeTab: investPositionsStore.activeInstrumentTab,
                            tabs: [
                              intl.invest_history_tab_invest,
                              intl.invest_history_tab_pending,
                            ],
                          ),
                        ],
                      ),
                      Observer(
                        builder: (BuildContext context) {
                          return investPositionsStore.activeInstrumentTab == 0
                            ? ActiveInvestList(
                              instrument: widget.instrument,
                            )
                            : PendingInvestList(
                              instrument: widget.instrument,
                            );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
