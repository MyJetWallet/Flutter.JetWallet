import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_new_store.dart';
import 'package:jetwallet/features/invest/ui/dashboard/invest_header.dart';
import 'package:jetwallet/features/invest/ui/invests/symbol_info_without_chart.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_button.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/custom/public/invest/simple_invest_buy.dart';
import 'package:simple_kit/modules/icons/custom/public/invest/simple_invest_chart_candles.dart';
import 'package:simple_kit/modules/icons/custom/public/invest/simple_invest_chart_line.dart';
import 'package:simple_kit/modules/icons/custom/public/invest/simple_invest_sell.dart';
import 'package:simple_kit/modules/shared/page_frames/simple_page_frame.dart';
import 'package:simple_kit/modules/shared/simple_divider.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';

import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../utils/formatting/base/volume_format.dart';
import '../../../utils/helpers/currency_from.dart';
import 'chart/invest_chart.dart';
import 'dashboard/new_invest_header.dart';
import 'invests/data_line.dart';
import 'invests/secondary_switch.dart';

@RoutePage(name: 'NewInvestConfirmationPageRouter')
class NewInvestConfirmationScreen extends StatefulObserverWidget {
  const NewInvestConfirmationScreen({
    super.key,
    required this.instrument,
  });

  final InvestInstrumentModel instrument;

  @override
  State<NewInvestConfirmationScreen> createState() => _NewInvestConfirmationScreenState();
}

class _NewInvestConfirmationScreenState extends State<NewInvestConfirmationScreen> {
  late ScrollController controller;
  late String price;
  late Timer updateTimer;

  @override
  void initState() {
    super.initState();
    final investStore = getIt.get<InvestDashboardStore>();
    final investNewStore = getIt.get<InvestNewStore>();
    price = investNewStore.isOrderMode
        ? '${investNewStore.pendingValue}'
        : '${investStore.getPendingPriceBySymbol(widget.instrument.symbol ?? '')}';

    updateTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {

        setState(() {
          price = investNewStore.isOrderMode
            ? '${investNewStore.pendingValue}'
            : '${investStore.getPendingPriceBySymbol(widget.instrument.symbol ?? '')}';
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
    final investNewStore = getIt.get<InvestNewStore>();
    final investStore = getIt.get<InvestDashboardStore>();

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
        height: 126,
        child: Column(
        children: [
          SPaddingH24(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DataLine(
                  fullWidth: false,
                  mainText: intl.invest_open_fee,
                  secondaryText: 'Est. ${volumeFormat(
                    decimal: investNewStore.amountValue *
                        Decimal.fromInt(investNewStore.multiplicator) *
                        (widget.instrument.openFee ?? Decimal.one),
                    accuracy: 2,
                    symbol: 'USDT',
                  )}',
                ),
                DataLine(
                  fullWidth: false,
                  mainText: intl.invest_volume,
                  secondaryText: volumeFormat(
                    decimal: investNewStore.amountValue *
                        Decimal.fromInt(investNewStore.multiplicator),
                    accuracy: 2,
                    symbol: 'USDT',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 98,
            child: Column(
              children: [
                const SpaceH20(),
                SPaddingH24(
                  child: SIButton(
                    onTap: () {
                      if (investNewStore.canClick) {
                        investNewStore.setCanClick(false);
                        Timer(
                          const Duration(
                            seconds: 2,
                          ),
                          () => investNewStore.setCanClick(true),
                        );
                      } else {
                        return;
                      }
                      investNewStore.createPosition();
                    },
                    name: investNewStore.isBuyMode
                      ? '${intl.invest_buy} $price'
                      : '${intl.invest_sell} $price',
                    description: investNewStore.isOrderMode ? intl.invest_pending_invest : null,
                    activeColor: investNewStore.isBuyMode ? colors.green : colors.red,
                    activeNameColor: colors.white,
                    icon: investNewStore.isBuyMode
                        ? SIBuyIcon(
                      width: 20,
                      height: 20,
                      color: colors.white,
                    )
                        : SISellIcon(
                      width: 20,
                      height: 20,
                      color: colors.white,
                    ),
                    active: true,
                    inactiveColor: investNewStore.isBuyMode ? colors.green : colors.red,
                    inactiveNameColor: colors.white,
                  ),
                ),
                const SpaceH34(),
              ],
            ),
          ),
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
              onTap: () {},
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
            NewInvestHeader(
              showRollover: false,
              showModify: false,
              showIcon: false,
              showFull: false,
              title: investNewStore.isOrderMode
                ? intl.invest_new_pending_title
                : intl.invest_new_title,
            ),
            DataLine(
              mainText: intl.invest_amount,
              secondaryText: volumeFormat(
                decimal: investNewStore.amountValue,
                accuracy: 2,
                symbol: 'USDT',
              ),
            ),
            const SpaceH8(),
            DataLine(
              mainText: intl.invest_multiplicator,
              secondaryText: 'x${investNewStore.multiplicator}',
            ),
            if (
              (investNewStore.isSl || investNewStore.isTP) &&
              investNewStore.isLimitsVisible
            ) ...[
              const SpaceH8(),
              const SDivider(),
              const SpaceH8(),
              NewInvestHeader(
                showRollover: false,
                showModify: false,
                showIcon: false,
                showFull: false,
                title: intl.invest_limits,
              ),
              if (investNewStore.isTP && investNewStore.tpAmountValue != Decimal.zero) ...[
                DataLine(
                  withDot: true,
                  dotColor: colors.green,
                  mainText: intl.invest_limits_take_profit,
                  secondaryText: volumeFormat(
                    decimal: investNewStore.tpAmountValue,
                    accuracy: 2,
                    symbol: 'USDT',
                  ),
                ),
                const SpaceH8(),
              ],
              if (investNewStore.isSl && investNewStore.slAmountValue != Decimal.zero) ...[
                DataLine(
                  withDot: true,
                  dotColor: colors.red,
                  mainText: intl.invest_limits_stop_loss,
                  secondaryText: volumeFormat(
                    decimal: investNewStore.slAmountValue,
                    accuracy: 2,
                    symbol: 'USDT',
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
