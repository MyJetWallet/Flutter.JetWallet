import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:charts/main.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_new_store.dart';
import 'package:jetwallet/features/invest/ui/dashboard/invest_header.dart';
import 'package:jetwallet/features/invest/ui/invests/symbol_info_without_chart.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/localized_chart_resolution_button.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';

import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../utils/helpers/currency_from.dart';
import 'dashboard/new_invest_header.dart';
import 'invests/data_line.dart';

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
    final isBalanceHide = getIt<AppStore>().isBalanceHide;

    final colors = SColorsLight();
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
                    secondaryText: isBalanceHide
                        ? '**** USDT'
                        : (investNewStore.amountValue *
                                Decimal.fromInt(investNewStore.multiplicator) *
                                (widget.instrument.openFee ?? Decimal.one))
                            .toFormatCount(
                            accuracy: 2,
                            symbol: 'USDT',
                          ),
                  ),
                  DataLine(
                    fullWidth: false,
                    mainText: intl.invest_volume,
                    secondaryText: isBalanceHide
                        ? '**** USDT'
                        : (investNewStore.amountValue * Decimal.fromInt(investNewStore.multiplicator)).toFormatCount(
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
                      name: investNewStore.isBuyMode ? '${intl.invest_buy} $price' : '${intl.invest_sell} $price',
                      description: investNewStore.isOrderMode ? intl.invest_pending_invest : null,
                      activeColor: investNewStore.isBuyMode ? colors.green : colors.red,
                      activeNameColor: colors.white,
                      icon: investNewStore.isBuyMode
                          ? Assets.svg.invest.buy.simpleSvg(
                              width: 20,
                              height: 20,
                              color: colors.white,
                            )
                          : Assets.svg.invest.sell.simpleSvg(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SPaddingH24(
            child: SymbolInfoWithoutChart(
              percent: investStore.getPercentSymbol(widget.instrument.symbol ?? ''),
              price: investStore.getPriceBySymbol(widget.instrument.symbol ?? ''),
              instrument: widget.instrument,
              onTap: () {},
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
                chartHeight: 243,
                chartWidgetHeight: 300,
                isAssetChart: true,
                loader: const LoaderSpinner(),
                accuracy: widget.instrument.priceAccuracy ?? 2,
              );
            },
          ),
          const SpaceH16(),
          SPaddingH24(
            child: NewInvestHeader(
              showRollover: false,
              showModify: false,
              showIcon: false,
              showFull: false,
              title: investNewStore.isOrderMode ? intl.invest_new_pending_title : intl.invest_new_title,
            ),
          ),
          SPaddingH24(
            child: DataLine(
              mainText: intl.invest_amount,
              secondaryText: isBalanceHide
                  ? '**** USDT'
                  : investNewStore.amountValue.toFormatCount(
                      accuracy: 2,
                      symbol: 'USDT',
                    ),
            ),
          ),
          const SpaceH8(),
          SPaddingH24(
            child: DataLine(
              mainText: intl.invest_multiplicator,
              secondaryText: 'x${investNewStore.multiplicator}',
            ),
          ),
          if ((investNewStore.isSl || investNewStore.isTP) && investNewStore.isLimitsVisible) ...[
            const SpaceH8(),
            const SPaddingH24(child: SDivider()),
            const SpaceH8(),
            SPaddingH24(
              child: NewInvestHeader(
                showRollover: false,
                showModify: false,
                showIcon: false,
                showFull: false,
                title: intl.invest_limits,
              ),
            ),
            if (investNewStore.isTP && investNewStore.tpAmountValue != Decimal.zero) ...[
              SPaddingH24(
                child: DataLine(
                  withDot: true,
                  dotColor: colors.green,
                  mainText: intl.invest_limits_take_profit,
                  secondaryText: isBalanceHide
                      ? '**** USDT'
                      : investNewStore.tpAmountValue.toFormatCount(
                          accuracy: 2,
                          symbol: 'USDT',
                        ),
                ),
              ),
              const SpaceH8(),
            ],
            if (investNewStore.isSl && investNewStore.slAmountValue != Decimal.zero) ...[
              SPaddingH24(
                child: DataLine(
                  withDot: true,
                  dotColor: colors.red,
                  mainText: intl.invest_limits_stop_loss,
                  secondaryText: isBalanceHide
                      ? '**** USDT'
                      : investNewStore.slAmountValue.toFormatCount(
                          accuracy: 2,
                          symbol: 'USDT',
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
