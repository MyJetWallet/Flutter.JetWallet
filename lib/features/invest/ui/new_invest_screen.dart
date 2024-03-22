import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_new_store.dart';
import 'package:jetwallet/features/invest/ui/dashboard/invest_header.dart';
import 'package:jetwallet/features/invest/ui/invests/buy_sell_switch.dart';
import 'package:jetwallet/features/invest/ui/invests/symbol_info_without_chart.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_input.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_market_watch_bottom_sheet.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_slider_input.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/button/invest_buttons/invest_button.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';

import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../utils/helpers/calculate_amount_points.dart';
import '../../../utils/helpers/currency_from.dart';
import 'chart/invest_chart.dart';
import 'invests/secondary_switch.dart';

@RoutePage(name: 'NewInvestPageRouter')
class NewInvestScreen extends StatefulObserverWidget {
  const NewInvestScreen({
    super.key,
    required this.instrument,
  });

  final InvestInstrumentModel instrument;

  @override
  State<NewInvestScreen> createState() => _NewInvestScreenState();
}

class _NewInvestScreenState extends State<NewInvestScreen> {
  bool canTapShare = true;
  late ScrollController controller;
  late WebViewController controllerWeb;

  @override
  void initState() {
    super.initState();
    final investNewStore = getIt.get<InvestNewStore>();
    final multiplicators = calculateMultiplyPositions(
      minVolume: Decimal.fromInt(widget.instrument.minMultiply ?? 0),
      maxVolume: Decimal.fromInt(widget.instrument.maxMultiply ?? 0),
    );
    investNewStore.resetStore();

    if ((sSignalRModules.investWalletData?.balance ?? Decimal.zero) > Decimal.zero) {
      final amounts = calculateAmountPositions(
        balance: sSignalRModules.investWalletData?.balance ?? Decimal.zero,
        minVolume: widget.instrument.minVolume ?? Decimal.zero,
        maxVolume: widget.instrument.maxVolume ?? Decimal.zero,
      );
      investNewStore.onAmountInput('${amounts[1]}');
      investNewStore.amountController.text = '${amounts[1]}';
    } else {
      investNewStore.onAmountInput('1');
      investNewStore.amountController.text = '1';
    }

    investNewStore.setInstrument(widget.instrument);
    investNewStore.setMultiplicator(multiplicators[1].toDouble().toInt());
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

    final colors = sKit.colors;
    final currency = currencyFrom(currencies, 'USDT');

    void changeOrderType(int type) {
      investNewStore.setIsOrderMode(type == 1);
    }

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
        height: 98,
        child: Column(
          children: [
            const SpaceH20(),
            SPaddingH24(
              child: SIButton(
                onTap: () {
                  if ((investNewStore.isOrderMode && investNewStore.hasPendingError()) ||
                      (!investNewStore.isOrderMode && investNewStore.hasActiveError())) {
                    return;
                  } else {
                    sRouter.push(
                      NewInvestConfirmationPageRouter(instrument: widget.instrument),
                    );
                  }
                },
                name: investNewStore.isBuyMode ? intl.invest_buy : intl.invest_sell,
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
      child: SPaddingH24(
        child: ListView(
          controller: controller,
          padding: EdgeInsets.zero,
          children: [
            SymbolInfoWithoutChart(
              percent: investStore.getPercentSymbol(widget.instrument.symbol ?? ''),
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
            Row(
              children: [
                BuySellSwitch(
                  onChangeTab: investNewStore.setIsBuyMode,
                  isBuy: investNewStore.isBuyMode,
                ),
                const Spacer(),
                SecondarySwitch(
                  onChangeTab: changeOrderType,
                  activeTab: investNewStore.isOrderMode ? 1 : 0,
                  fullWidth: false,
                  tabs: [
                    intl.invest_history_tab_invest,
                    intl.invest_history_tab_pending,
                  ],
                ),
              ],
            ),
            const SpaceH8(),
            Text(
              intl.invest_amount,
              style: STStyles.body2InvestM.copyWith(
                color: colors.black,
              ),
            ),
            const SpaceH4(),
            InvestInput(
              onChanged: investNewStore.onAmountInput,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              ],
              icon: Row(
                children: [
                  SvgPicture.network(
                    currency.iconUrl,
                    width: 16.0,
                    height: 16.0,
                    placeholderBuilder: (_) {
                      return const SAssetPlaceholderIcon();
                    },
                  ),
                  const SpaceW2(),
                  Text(
                    currency.symbol,
                    style: STStyles.body2InvestM.copyWith(
                      color: colors.black,
                    ),
                  ),
                  const SpaceW10(),
                ],
              ),
              controller: investNewStore.amountController,
              keyboardType: TextInputType.number,
            ),
            if (sSignalRModules.investWalletData!.balance! >= Decimal.fromInt(30)) ...[
              const SpaceH8(),
              InvestSliderInput(
                maxValue: calculateAmountMax(
                  balance: sSignalRModules.investWalletData?.balance ?? Decimal.zero,
                  minVolume: widget.instrument.minVolume ?? Decimal.zero,
                  maxVolume: widget.instrument.maxVolume ?? Decimal.zero,
                ),
                minValue: calculateAmountMin(
                  balance: sSignalRModules.investWalletData?.balance ?? Decimal.zero,
                  minVolume: widget.instrument.minVolume ?? Decimal.zero,
                  maxVolume: widget.instrument.maxVolume ?? Decimal.zero,
                ),
                currentValue: investNewStore.amountValue == Decimal.zero
                    ? Decimal.zero
                    : Decimal.fromJson('${log(investNewStore.amountValue.toDouble())}'),
                divisions: ((calculateAmountMaxReal(
                              balance: sSignalRModules.investWalletData?.balance ?? Decimal.zero,
                              minVolume: widget.instrument.minVolume ?? Decimal.zero,
                              maxVolume: widget.instrument.maxVolume ?? Decimal.zero,
                            ) -
                            calculateAmountMinReal(
                              balance: sSignalRModules.investWalletData?.balance ?? Decimal.zero,
                              minVolume: widget.instrument.minVolume ?? Decimal.zero,
                              maxVolume: widget.instrument.maxVolume ?? Decimal.zero,
                            )) *
                        Decimal.fromInt(1000))
                    .toDouble()
                    .floor(),
                isLog: true,
                prefix: '    ',
                arrayOfValues: calculateAmountPositions(
                  balance: sSignalRModules.investWalletData?.balance ?? Decimal.zero,
                  minVolume: widget.instrument.minVolume ?? Decimal.zero,
                  maxVolume: widget.instrument.maxVolume ?? Decimal.zero,
                ),
                onChange: (double value) {
                  investNewStore.onAmountInput('${value.toInt()}');
                  investNewStore.amountController.text = '${value.toInt()}';
                },
              ),
            ],
            const SpaceH12(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  intl.invest_multiplicator,
                  style: STStyles.body2InvestM.copyWith(
                    color: colors.black,
                  ),
                ),
                Text(
                  'x${investNewStore.multiplicator}',
                  style: STStyles.body1InvestSM.copyWith(
                    color: colors.black,
                  ),
                ),
              ],
            ),
            const SpaceH8(),
            InvestSliderInput(
              maxValue: Decimal.fromInt(widget.instrument.maxMultiply ?? 0),
              minValue: Decimal.fromInt(widget.instrument.minMultiply ?? 0),
              currentValue: Decimal.fromInt(investNewStore.multiplicator),
              divisions: 4,
              prefix: 'x',
              fullScale: true,
              arrayOfValues: calculateMultiplyPositions(
                minVolume: Decimal.fromInt(widget.instrument.minMultiply ?? 0),
                maxVolume: Decimal.fromInt(widget.instrument.maxMultiply ?? 0),
              ),
              onChange: (double value) {
                investNewStore.setMultiplicator(value.toInt());
              },
            ),
            const SpaceH12(),
            if (investNewStore.isOrderMode) ...[
              Text(
                intl.invest_pending_price,
                style: STStyles.body2InvestM.copyWith(
                  color: colors.black,
                ),
              ),
              const SpaceH4(),
              InvestInput(
                onChanged: investNewStore.onPendingInput,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp('[0-9,.]')),
                ],
                controller: investNewStore.pendingPriceController,
                keyboardType: TextInputType.number,
              ),
              const SpaceH12(),
            ],
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    intl.invest_limits,
                    style: STStyles.body1InvestSM.copyWith(
                      color: colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      if (investNewStore.isLimitsVisible) ...[
                        SecondarySwitch(
                          onChangeTab: (value) {
                            investNewStore.setIsSLTPPrice(
                              value == 1,
                            );
                          },
                          activeTab: investNewStore.isSLTPPrice ? 1 : 0,
                          fullWidth: false,
                          tabs: [
                            'USDT',
                            intl.invest_price,
                          ],
                        ),
                        const SpaceW10(),
                        Transform.rotate(
                          angle: pi,
                          child: SIconButton(
                            onTap: () {
                              investNewStore.setIsLimitsVisible(false);
                            },
                            defaultIcon: Assets.svg.invest.investArrow.simpleSvg(
                              width: 24,
                              height: 24,
                              color: colors.black,
                            ),
                          ),
                        ),
                      ] else
                        SIconButton(
                          onTap: () {
                            investNewStore.setIsLimitsVisible(true);
                            Timer(
                              const Duration(milliseconds: 100),
                              () {
                                controller.animateTo(
                                  controller.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn,
                                );
                              },
                            );
                          },
                          defaultIcon: Assets.svg.invest.investArrow.simpleSvg(
                            width: 24,
                            height: 24,
                            color: colors.black,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (investNewStore.isLimitsVisible) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceH6(),
                  Row(
                    children: [
                      SIconButton(
                        onTap: () {
                          investNewStore.setIsTPMode(!investNewStore.isTP);
                          Timer(
                            const Duration(milliseconds: 100),
                            () {
                              controller.animateTo(
                                controller.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn,
                              );
                            },
                          );
                        },
                        defaultIcon: investNewStore.isTP
                            ? Assets.svg.invest.checked.simpleSvg(
                                width: 20,
                                height: 20,
                              )
                            : Assets.svg.invest.check.simpleSvg(
                                width: 20,
                                height: 20,
                              ),
                        pressedIcon: investNewStore.isTP
                            ? Assets.svg.invest.checked.simpleSvg(
                                width: 20,
                                height: 20,
                              )
                            : Assets.svg.invest.check.simpleSvg(
                                width: 20,
                                height: 20,
                              ),
                      ),
                      const SpaceW4(),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SpaceW4(),
                      Text(
                        intl.invest_limits_take_profit,
                        style: STStyles.body2InvestM.copyWith(
                          color: colors.black,
                        ),
                      ),
                    ],
                  ),
                  if (investNewStore.isTP) ...[
                    const SpaceH4(),
                    Row(
                      children: [
                        Expanded(
                          child: InvestInput(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp('[0-9-]')),
                            ],
                            onChanged: investNewStore.onTPAmountInput,
                            icon: Row(
                              children: [
                                Text(
                                  currency.symbol,
                                  style: STStyles.body2InvestM.copyWith(
                                    color: colors.black,
                                  ),
                                ),
                                const SpaceW10(),
                              ],
                            ),
                            controller: investNewStore.tpAmountController,
                            keyboardType: TextInputType.number,
                            enabled: !investNewStore.isSLTPPrice,
                          ),
                        ),
                        const SpaceW12(),
                        Expanded(
                          child: InvestInput(
                            onChanged: investNewStore.onTPPriceInput,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp('[0-9,.]')),
                            ],
                            icon: const SizedBox(),
                            controller: investNewStore.tpPriceController,
                            keyboardType: TextInputType.number,
                            enabled: investNewStore.isSLTPPrice,
                          ),
                        ),
                      ],
                    ),
                    if (widget.instrument.takeProfitAmountLimits != null &&
                        widget.instrument.takeProfitAmountLimits!.isNotEmpty &&
                        widget.instrument.takeProfitPriceLimits != null &&
                        widget.instrument.takeProfitPriceLimits!.isNotEmpty) ...[
                      const SpaceH8(),
                      InvestSliderInput(
                        maxValue: calculateLimitsPositions(
                          price: investNewStore.isOrderMode
                              ? investNewStore.pendingValue
                              : investStore.getPendingPriceBySymbol(widget.instrument.symbol ?? ''),
                          amount: investNewStore.amountValue,
                          limits: investNewStore.isSLTPPrice
                              ? widget.instrument.takeProfitPriceLimits!
                              : widget.instrument.takeProfitAmountLimits!,
                          isAmount: !investNewStore.isSLTPPrice,
                          isSl: false,
                        )[4],
                        minValue: calculateLimitsPositions(
                          price: investNewStore.isOrderMode
                              ? investNewStore.pendingValue
                              : investStore.getPendingPriceBySymbol(widget.instrument.symbol ?? ''),
                          amount: investNewStore.amountValue,
                          limits: investNewStore.isSLTPPrice
                              ? widget.instrument.takeProfitPriceLimits!
                              : widget.instrument.takeProfitAmountLimits!,
                          isAmount: !investNewStore.isSLTPPrice,
                          isSl: false,
                        )[0],
                        currentValue:
                            investNewStore.isSLTPPrice ? investNewStore.tpPriceValue : investNewStore.tpAmountValue,
                        divisions: 4,
                        withArray: true,
                        fullScale: !investNewStore.isSLTPPrice,
                        arrayOfValues: calculateLimitsPositions(
                          price: investNewStore.isOrderMode
                              ? investNewStore.pendingValue
                              : investStore.getPendingPriceBySymbol(widget.instrument.symbol ?? ''),
                          amount: investNewStore.amountValue,
                          limits: investNewStore.isSLTPPrice
                              ? widget.instrument.takeProfitPriceLimits!
                              : widget.instrument.takeProfitAmountLimits!,
                          isAmount: !investNewStore.isSLTPPrice,
                          isSl: false,
                        ),
                        onChange: (double value) {
                          if (investNewStore.isSLTPPrice) {
                            investNewStore.onTPPriceInput('$value');
                            investNewStore.tpPriceController.text = '$value';
                          } else {
                            investNewStore.onTPAmountInput('${value.toInt()}');
                            investNewStore.tpAmountController.text = '${value.toInt()}';
                          }
                        },
                      ),
                    ],
                    const SpaceH12(),
                  ] else
                    const SpaceH12(),
                  Row(
                    children: [
                      SIconButton(
                        onTap: () {
                          investNewStore.setIsSLMode(!investNewStore.isSl);
                          Timer(
                            const Duration(milliseconds: 100),
                            () {
                              controller.animateTo(
                                controller.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn,
                              );
                            },
                          );
                        },
                        defaultIcon: investNewStore.isSl
                            ? Assets.svg.invest.checked.simpleSvg(
                                width: 20,
                                height: 20,
                              )
                            : Assets.svg.invest.check.simpleSvg(
                                width: 20,
                                height: 20,
                              ),
                        pressedIcon: investNewStore.isSl
                            ? Assets.svg.invest.checked.simpleSvg(
                                width: 20,
                                height: 20,
                              )
                            : Assets.svg.invest.check.simpleSvg(
                                width: 20,
                                height: 20,
                              ),
                      ),
                      const SpaceW4(),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SpaceW4(),
                      Text(
                        intl.invest_limits_stop_loss,
                        style: STStyles.body2InvestM.copyWith(
                          color: colors.black,
                        ),
                      ),
                    ],
                  ),
                  if (investNewStore.isSl) ...[
                    const SpaceH4(),
                    Row(
                      children: [
                        Expanded(
                          child: InvestInput(
                            onChanged: investNewStore.onSLAmountInput,
                            icon: Row(
                              children: [
                                Text(
                                  currency.symbol,
                                  style: STStyles.body2InvestM.copyWith(
                                    color: colors.black,
                                  ),
                                ),
                                const SpaceW10(),
                              ],
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp('[0-9-]')),
                            ],
                            controller: investNewStore.slAmountController,
                            keyboardType: TextInputType.number,
                            enabled: !investNewStore.isSLTPPrice,
                          ),
                        ),
                        const SpaceW12(),
                        Expanded(
                          child: InvestInput(
                            onChanged: investNewStore.onSLPriceInput,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp('[0-9,.]')),
                            ],
                            icon: const SizedBox(),
                            controller: investNewStore.slPriceController,
                            keyboardType: TextInputType.number,
                            enabled: investNewStore.isSLTPPrice,
                          ),
                        ),
                      ],
                    ),
                    if (widget.instrument.stopLossAmountLimits != null &&
                        widget.instrument.stopLossAmountLimits!.isNotEmpty &&
                        widget.instrument.stopLossPriceLimits != null &&
                        widget.instrument.stopLossPriceLimits!.isNotEmpty) ...[
                      const SpaceH8(),
                      InvestSliderInput(
                        maxValue: calculateLimitsPositions(
                          price: investNewStore.isOrderMode
                              ? investNewStore.pendingValue
                              : investStore.getPendingPriceBySymbol(widget.instrument.symbol ?? ''),
                          amount: investNewStore.amountValue,
                          limits: investNewStore.isSLTPPrice
                              ? widget.instrument.stopLossPriceLimits!
                              : widget.instrument.stopLossAmountLimits!,
                          isAmount: !investNewStore.isSLTPPrice,
                          isSl: true,
                        )[4]
                            .abs(),
                        minValue: calculateLimitsPositions(
                          price: investNewStore.isOrderMode
                              ? investNewStore.pendingValue
                              : investStore.getPendingPriceBySymbol(widget.instrument.symbol ?? ''),
                          amount: investNewStore.amountValue,
                          limits: investNewStore.isSLTPPrice
                              ? widget.instrument.stopLossPriceLimits!
                              : widget.instrument.stopLossAmountLimits!,
                          isAmount: !investNewStore.isSLTPPrice,
                          isSl: true,
                        )[0]
                            .abs(),
                        currentValue: investNewStore.isSLTPPrice
                            ? investNewStore.slPriceValue
                            : investNewStore.slAmountValue.abs(),
                        divisions: 4,
                        withArray: true,
                        fullScale: !investNewStore.isSLTPPrice,
                        arrayOfValues: calculateLimitsPositions(
                          price: investNewStore.isOrderMode
                              ? investNewStore.pendingValue
                              : investStore.getPendingPriceBySymbol(widget.instrument.symbol ?? ''),
                          amount: investNewStore.amountValue,
                          limits: investNewStore.isSLTPPrice
                              ? widget.instrument.stopLossPriceLimits!
                              : widget.instrument.stopLossAmountLimits!,
                          isAmount: !investNewStore.isSLTPPrice,
                          isSl: true,
                        ),
                        onChange: (double value) {
                          if (investNewStore.isSLTPPrice) {
                            investNewStore.onSLPriceInput('$value');
                            investNewStore.slPriceController.text = '${value.abs()}';
                          } else {
                            investNewStore.onSLAmountInput('${value.toInt()}');
                            investNewStore.slAmountController.text = '-${value.abs().toInt()}';
                          }
                        },
                      ),
                    ],
                    const SpaceH12(),
                  ] else
                    const SpaceH6(),
                ],
              ),
            ],
            if (investNewStore.isLimitsVisible) const SpaceH40() else const SDivider(),
          ],
        ),
      ),
    );
  }
}
