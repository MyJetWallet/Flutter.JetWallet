import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_new_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_positions_store.dart';
import 'package:jetwallet/features/invest/ui/dashboard/invest_header.dart';
import 'package:jetwallet/features/invest/ui/invests/above_list_line.dart';
import 'package:jetwallet/features/invest/ui/invests/symbol_info_without_chart.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_close_bottom_sheet.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_market_watch_bottom_sheet.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/shared/page_frames/simple_page_frame.dart';
import 'package:simple_kit/modules/shared/simple_divider.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/button/invest_buttons/invest_button.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';

import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../utils/formatting/base/volume_format.dart';
import '../../../utils/helpers/currency_from.dart';
import 'chart/invest_chart.dart';
import 'dashboard/new_invest_header.dart';
import 'invests/data_line.dart';
import 'invests/invest_line.dart';
import 'invests/secondary_switch.dart';

@RoutePage(name: 'PendingInvestManageRouter')
class PendingInvestManageScreen extends StatefulObserverWidget {
  const PendingInvestManageScreen({
    super.key,
    required this.instrument,
    required this.position,
  });

  final InvestInstrumentModel instrument;
  final InvestPositionModel position;

  @override
  State<PendingInvestManageScreen> createState() => _PendingInvestManageScreenState();
}

class _PendingInvestManageScreenState extends State<PendingInvestManageScreen> {
  late ScrollController controller;
  late Timer updateTimer;
  late String timerUpdated;

  @override
  void initState() {
    super.initState();
    final investNewStore = getIt.get<InvestNewStore>();
    final investPositionStore = getIt.get<InvestPositionsStore>();
    investNewStore.setPosition(widget.position);
    investPositionStore.initPosition(widget.position);
    final a = DateTime.parse('${widget.instrument.nextRollOverTime}');
    final b = DateTime.now();
    final difference = a.difference(b);
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;
    timerUpdated = '-$hours:'
        '${minutes < 10 ? '0' : ''}$minutes:'
        '${seconds < 10 ? '0' : ''}$seconds';

    updateTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
          final a = DateTime.parse('${widget.instrument.nextRollOverTime}');
          final b = DateTime.now();
          final difference = a.difference(b);
          final hours = difference.inHours % 24;
          final minutes = difference.inMinutes % 60;
          final seconds = difference.inSeconds % 60;
          setState(() {
            timerUpdated = '-$hours:'
                '${minutes < 10 ? '0' : ''}$minutes:'
                '${seconds < 10 ? '0' : ''}$seconds';
          });
      },
    );
    controller = ScrollController();
  }

  @override
  void dispose() {
    updateTimer.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;
    final investPositionStore = getIt.get<InvestPositionsStore>();
    final investStore = getIt.get<InvestDashboardStore>();
    final investNewStore = getIt.get<InvestNewStore>();

    final colors = sKit.colors;
    final currency = currencyFrom(currencies, 'USDT');

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      loading: investNewStore.loader,
      header: SPaddingH24(
        child: InvestHeader(
          currency: currency,
          withBackBlock: true,
          onBackButton: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar:SizedBox(
        height: 98,
        child: Column(
          children: [
            const SpaceH20(),
            SPaddingH24(
              child: SIButton(
                onTap: () {
                  showInvestCloseBottomSheet(
                    context: context,
                    isProfit: investStore.getProfitByPosition(investNewStore.position!) > Decimal.zero,
                    onPrimaryButtonTap: () {
                      Navigator.pop(context);
                    },
                    onSecondaryButtonTap: () {
                      investPositionStore.closeActivePosition(
                        context,
                        investNewStore.position!,
                        widget.instrument,
                      );
                    },
                    primaryButtonName: intl.invest_alert_cancel,
                    secondaryButtonName: intl.invest_close,
                    widget: Column(
                      children: [
                        AboveListLine(
                          mainColumn: intl.invest_list_instrument,
                          secondaryColumn: '${intl.invest_amount} (USDT)',
                          lastColumn: '${intl.invest_alert_close_all_profit} (USDT)',
                          onCheckboxTap: (value) {},
                        ),
                        InvestLine(
                          currency: currencyFrom(currencies, widget.instrument.name ?? ''),
                          price: investStore.getProfitByPosition(investNewStore.position!),
                          operationType: investNewStore.position!.direction ?? Direction.undefined,
                          isPending: false,
                          amount: investNewStore.position!.amount ?? Decimal.zero,
                          leverage: Decimal.fromInt(investNewStore.position!.multiplicator ?? 0),
                          isGroup: false,
                          historyCount: 1,
                          profit: investStore.getProfitByPosition(investNewStore.position!),
                          profitPercent: investStore.getYieldByPosition(investNewStore.position!),
                          accuracy: widget.instrument.priceAccuracy ?? 2,
                          onTap: () {},
                        ),
                        const SPaddingH24(child: SDivider()),
                        const SpaceH16(),
                        DataLine(
                          mainText: intl.invest_price,
                          secondaryText: volumeFormat(
                            decimal: investStore.getPendingPriceBySymbol(widget.instrument.symbol ?? ''),
                            accuracy: widget.instrument.priceAccuracy ?? 2,
                            symbol: '',
                          ),
                        ),
                        const SpaceH16(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DataLine(
                              fullWidth: false,
                              mainText: intl.invest_close_fee,
                              secondaryText: 'Est. ${volumeFormat(
                                decimal: (investNewStore.position!.volumeBase ?? Decimal.zero) *
                                    investStore.getPendingPriceBySymbol(widget.instrument.symbol ?? '') *
                                    (widget.instrument.closeFee ?? Decimal.zero),
                                accuracy: widget.instrument.priceAccuracy ?? 2,
                                symbol: 'USDT',
                              )}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                name: intl.invest_close,
                activeColor: colors.black,
                activeNameColor: investStore.getProfitByPosition(investNewStore.position!) > Decimal.zero
                    ? colors.green
                    : colors.red,
                active: true,
                inactiveColor: colors.black,
                inactiveNameColor: colors.white,
              ),
            ),
            const SpaceH34(),
          ],
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
                        Assets.svg.invest.chartLine.simpleSvg(
                          width: 16,
                          height: 16,
                          color: investNewStore.chartType == 0 ? colors.black : colors.grey2,
                        ),
                        Assets.svg.invest.chartCandles.simpleSvg(
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
            InvestLine(
              currency: currencyFrom(currencies, widget.instrument.name ?? ''),
              price: widget.position.profitLoss ?? Decimal.zero,
              operationType: widget.position.direction ?? Direction.undefined,
              isPending: true,
              amount: widget.position.amount ?? Decimal.zero,
              leverage: Decimal.fromInt(widget.position.multiplicator ?? 0),
              isGroup: false,
              historyCount: 1,
              profit: investStore.getProfitByPosition(widget.position),
              profitPercent: investStore.getYieldByPosition(widget.position),
              accuracy: widget.instrument.priceAccuracy ?? 2,
              onTap: () {},
            ),
            const SDivider(),
            const SpaceH8(),
            NewInvestHeader(
              showRollover: false,
              showModify: false,
              showIcon: false,
              showFull: false,
              title: intl.invest_pending_invest,
            ),
            DataLine(
              mainText: intl.invest_trigger_price,
              secondaryText: marketFormat(
                decimal: investNewStore.position!.pendingPrice ?? Decimal.zero,
                accuracy: 2,
                symbol: '',
              ),
            ),
            const SpaceH8(),
            DataLine(
              mainText: intl.invest_s_o_price,
              secondaryText: marketFormat(
                decimal: investNewStore.position!.stopOutPrice ?? Decimal.zero,
                accuracy: 2,
                symbol: '',
              ),
            ),
            const SpaceH11(),
            NewInvestHeader(
              showRollover: false,
              showModify: false,
              showIcon: false,
              showFull: false,
              title: intl.invest_limits,
            ),
            if (
            investNewStore.position!.stopLossType != TPSLType.undefined ||
                investNewStore.position!.takeProfitType != TPSLType.undefined
            ) ...[
              if (investNewStore.position!.takeProfitType != TPSLType.undefined) ...[
                DataLine(
                  withDot: true,
                  dotColor: colors.green,
                  mainText: intl.invest_limits_take_profit,
                  secondaryText: investNewStore.position!.takeProfitType == TPSLType.amount
                      ? volumeFormat(
                    decimal: investNewStore.position!.takeProfitAmount ?? Decimal.zero,
                    accuracy: 2,
                    symbol: 'USDT',
                  ) : volumeFormat(
                    decimal: investNewStore.position!.takeProfitPrice ?? Decimal.zero,
                    accuracy: widget.instrument.priceAccuracy ?? 2,
                    symbol: '',
                  ),
                ),
                const SpaceH8(),
              ],
              if (investNewStore.position!.stopLossType != TPSLType.undefined) ...[
                DataLine(
                  withDot: true,
                  dotColor: colors.red,
                  mainText: intl.invest_limits_stop_loss,
                  secondaryText: investNewStore.position!.stopLossType == TPSLType.amount
                      ? volumeFormat(
                    decimal: investNewStore.position!.stopLossAmount ?? Decimal.zero,
                    accuracy: 2,
                    symbol: 'USDT',
                  ) : volumeFormat(
                    decimal: investNewStore.position!.stopLossPrice ?? Decimal.zero,
                    accuracy: widget.instrument.priceAccuracy ?? 2,
                    symbol: '',
                  ),
                ),
                const SpaceH8(),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
