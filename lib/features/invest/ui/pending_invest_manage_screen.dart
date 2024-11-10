import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:charts/main.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_new_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_positions_store.dart';
import 'package:jetwallet/features/invest/ui/dashboard/invest_header.dart';
import 'package:jetwallet/features/invest/ui/invests/symbol_info_without_chart.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_alert_bottom_sheet.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_market_watch_bottom_sheet.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_modify_bottom_sheet.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/localized_chart_resolution_button.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/shared/simple_divider.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';
import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../utils/helpers/currency_from.dart';
import 'dashboard/new_invest_header.dart';
import 'invests/data_line.dart';
import 'invests/invest_line.dart';

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
    final investPositionsStore = getIt.get<InvestPositionsStore>();
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
      bottomNavigationBar: SizedBox(
        height: 98.0,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SpaceH20(),
              SPaddingH24(
                child: Row(
                  children: [
                    Expanded(
                      child: SIButton(
                        activeColor: colors.black,
                        activeNameColor: colors.white,
                        inactiveColor: colors.grey2,
                        inactiveNameColor: colors.grey4,
                        active: true,
                        icon: Assets.svg.invest.investClose.simpleSvg(
                          width: 20,
                          height: 20,
                        ),
                        name: intl.invest_delete,
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
                              investPositionsStore.cancelPending(
                                context,
                                widget.position.id,
                              );
                            },
                            primaryButtonName: intl.invest_alert_cancel,
                            secondaryButtonName: intl.invest_delete,
                            title: intl.invest_alert_delete_pending_order,
                            subtitle: intl.invest_alert_delete_pending_order_sub_titile,
                          );
                        },
                      ),
                    ),
                    const SpaceW10(),
                    Expanded(
                      child: SIButton(
                        borderColor: colors.blue,
                        activeColor: colors.white,
                        activeNameColor: colors.blue,
                        inactiveColor: colors.grey4,
                        inactiveNameColor: colors.grey2,
                        active: true,
                        icon: Assets.svg.invest.edit.simpleSvg(
                          width: 20,
                          height: 20,
                        ),
                        name: intl.invest_modify,
                        onTap: () {
                          showInvestModifyBottomSheet(
                            context: context,
                            isPendingInvest: true,
                            instrument: widget.instrument,
                            position: investNewStore.position!,
                            onPrimaryButtonTap: () {
                              Navigator.pop(context);
                            },
                            onSecondaryButtonTap: () {
                              investNewStore.saveLimits(investNewStore.position!.id!);
                            },
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
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SPaddingH24(
            child: SymbolInfoWithoutChart(
              percent: investStore.getPercentSymbol(widget.instrument.symbol ?? ''),
              price: investStore.getPriceBySymbol(widget.instrument.symbol ?? ''),
              instrument: widget.instrument,
              onTap: () {
                investStore.setActiveSection('all');
                showInvestMarketWatchBottomSheet(context);
              },
            ),
          ),
          const SpaceH8(),
          Observer(
            builder: (BuildContext context) {
              return Chart(
                localizedChartResolutionButton: localizedChartResolutionButton(context),
                onResolutionChanged: (resolution) {
                  investNewStore.updateResolution(
                    resolution,
                    widget.instrument.symbol ?? '',
                  );
                },
                onChartTypeChanged: (type) {},
                candleResolution: investNewStore.resolution,
                formatPrice: ({
                  required int accuracy,
                  required Decimal decimal,
                  required bool onlyFullPart,
                  required String symbol,
                  required String prefix,
                }) {
                  return decimal.toFormatSum(
                    accuracy: accuracy,
                    symbol: symbol,
                  );
                },
                candles: investNewStore.candles[investNewStore.resolution],
                onCandleSelected: (value) {},
                chartHeight: 240,
                chartWidgetHeight: 297,
                isAssetChart: true,
                loader: const LoaderSpinner(),
                accuracy: widget.instrument.priceAccuracy ?? 2,
              );
            },
          ),
          const SpaceH16(),
          SPaddingH24(
            child: InvestLine(
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
          ),
          const SPaddingH24(child: SDivider()),
          const SpaceH8(),
          SPaddingH24(
            child: NewInvestHeader(
              showRollover: false,
              showModify: false,
              showIcon: false,
              showFull: false,
              title: intl.invest_pending_invest,
            ),
          ),
          SPaddingH24(
            child: DataLine(
              mainText: intl.invest_pending_price,
              secondaryText: (investNewStore.position!.pendingPrice ?? Decimal.zero).toFormatSum(
                accuracy: widget.instrument.priceAccuracy ?? 2,
              ),
            ),
          ),
          const SpaceH8(),
          if (investNewStore.position!.stopLossType != TPSLType.undefined ||
              investNewStore.position!.takeProfitType != TPSLType.undefined) ...[
            if (investNewStore.position!.takeProfitType != TPSLType.undefined) ...[
              SPaddingH24(
                child: NewInvestHeader(
                  showRollover: false,
                  showModify: false,
                  showIcon: false,
                  showFull: false,
                  onButtonTap: () {},
                  title: intl.invest_limits,
                ),
              ),
              SPaddingH24(
                child: DataLine(
                  withDot: true,
                  dotColor: colors.green,
                  mainText: intl.invest_limits_take_profit,
                  secondaryText: investNewStore.position!.takeProfitType == TPSLType.amount
                      ? (investNewStore.position!.takeProfitAmount ?? Decimal.zero).toFormatCount(
                          accuracy: 2,
                          symbol: 'USDT',
                        )
                      : (investNewStore.position!.takeProfitPrice ?? Decimal.zero).toFormatCount(
                          accuracy: widget.instrument.priceAccuracy ?? 2,
                        ),
                ),
              ),
              const SpaceH8(),
            ],
            if (investNewStore.position!.stopLossType != TPSLType.undefined) ...[
              SPaddingH24(
                child: DataLine(
                  withDot: true,
                  dotColor: colors.red,
                  mainText: intl.invest_limits_stop_loss,
                  secondaryText: investNewStore.position!.stopLossType == TPSLType.amount
                      ? (investNewStore.position!.stopLossAmount ?? Decimal.zero).toFormatCount(
                          accuracy: 2,
                          symbol: 'USDT',
                        )
                      : (investNewStore.position!.stopLossPrice ?? Decimal.zero).toFormatCount(
                          accuracy: widget.instrument.priceAccuracy ?? 2,
                        ),
                ),
              ),
              const SpaceH8(),
            ],
          ],
        ],
      ),
    );
  }
}
