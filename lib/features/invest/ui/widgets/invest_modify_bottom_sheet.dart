import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_button.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';

import '../../../../core/di/di.dart';
import '../../../../core/l10n/i10n.dart';
import '../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../utils/helpers/calculate_amount_points.dart';
import '../../../../utils/helpers/currency_from.dart';
import '../../stores/dashboard/invest_dashboard_store.dart';
import '../../stores/dashboard/invest_new_store.dart';
import '../invests/secondary_switch.dart';
import 'invest_input.dart';
import 'invest_slider_input.dart';

void showInvestModifyBottomSheet({
  required BuildContext context,
  required InvestInstrumentModel instrument,
  required InvestPositionModel position,
  required Function() onPrimaryButtonTap,
  required Function() onSecondaryButtonTap,
}) {
  final investNewStore = getIt.get<InvestNewStore>();
  investNewStore.resetStore();
  investNewStore.setPosition(position);
  investNewStore.setInstrument(instrument);
  investNewStore.setIsBuyMode(position.direction == Direction.buy);
  investNewStore.setIsSLMode(position.stopLossType != TPSLType.undefined);
  investNewStore.setIsTPMode(position.takeProfitType != TPSLType.undefined);
  investNewStore.setIsLimitsVisible(true);
  investNewStore.setIsOrderMode(false);
  investNewStore.setIsSLTPPrice(
    position.stopLossType == TPSLType.price ||
        position.takeProfitType == TPSLType.price,
  );
  investNewStore.setMultiplicator(position.multiplicator!);
  investNewStore.onAmountInput('${position.amount}');
  if (position.takeProfitType == TPSLType.price) {
    investNewStore.onTPPriceInput('${position.takeProfitPrice}');
  } else if (position.takeProfitType == TPSLType.amount) {
    investNewStore.onTPAmountInput('${position.takeProfitAmount}');
  }
  if (position.stopLossType == TPSLType.price) {
    investNewStore.onSLPriceInput('${position.stopLossPrice}');
  } else if (position.stopLossType == TPSLType.amount) {
    investNewStore.onSLAmountInput('${position.stopLossAmount}');
  }

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinnedBottom: Material(
      color: SColorsLight().white,
      child: Observer(
        builder: (BuildContext context) {
          return SizedBox(
            height: 98.0,
            child: Column(
              children: [
                const SpaceH20(),
                SPaddingH24(
                  child: Row(
                    children: [
                      Expanded(
                        child: SIButton(
                          activeColor: SColorsLight().grey5,
                          activeNameColor: SColorsLight().black,
                          inactiveColor: SColorsLight().grey2,
                          inactiveNameColor: SColorsLight().grey4,
                          active: true,
                          name: intl.invest_cancel,
                          onTap: () {
                            onPrimaryButtonTap();
                          },
                        ),
                      ),
                      const SpaceW10(),
                      Expanded(
                        child: SIButton(
                          activeColor: SColorsLight().blue,
                          activeNameColor: SColorsLight().white,
                          inactiveColor: SColorsLight().grey4,
                          inactiveNameColor: SColorsLight().grey2,
                          active: true,
                          name: intl.invest_save,
                          onTap: () {
                            onSecondaryButtonTap.call();
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
    horizontalPinnedPadding: 0,
    removePinnedPadding: true,
    horizontalPadding: 0,
    children: [InfoBlock(
      instrument: instrument,
      position: position,
    ),],
  );
}

class InfoBlock extends StatelessObserverWidget {
  const InfoBlock({
    super.key,
    required this.instrument,
    required this.position,
  });

  final InvestInstrumentModel instrument;
  final InvestPositionModel position;

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;
    final investNewStore = getIt.get<InvestNewStore>();
    final investStore = getIt.get<InvestDashboardStore>();

    final colors = sKit.colors;
    final currency = currencyFrom(currencies, 'USDT');

    return SPaddingH24(
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  intl.invest_limits,
                  style: sBody1InvestSMStyle.copyWith(
                    color: colors.black,
                  ),
                ),
                Row(
                  children: [
                    SecondarySwitch(
                      onChangeTab: (value) {
                        investNewStore.setIsSLTPPrice(
                          value == 1,
                        );
                      },
                      activeTab: investNewStore.isSLTPPrice
                          ? 1
                          : 0,
                      fullWidth: false,
                      tabs: [
                        'USDT',
                        intl.invest_price,
                      ],
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
                      },
                      defaultIcon: investNewStore.isTP
                          ? const SICheckedIcon(width: 20, height: 20,)
                          : const SICheckIcon(width: 20, height: 20,),
                      pressedIcon: investNewStore.isTP
                          ? const SICheckedIcon(width: 20, height: 20,)
                          : const SICheckIcon(width: 20, height: 20,),
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
                      style: sBody2InvestMStyle.copyWith(
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
                                style: sBody2InvestMStyle.copyWith(
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
                  if (
                    instrument.takeProfitAmountLimits != null &&
                    instrument.takeProfitAmountLimits!.isNotEmpty &&
                    instrument.takeProfitPriceLimits != null &&
                    instrument.takeProfitPriceLimits!.isNotEmpty
                  ) ...[
                    const SpaceH8(),
                    InvestSliderInput(
                      maxValue: calculateLimitsPositions(
                        price: investNewStore.isOrderMode
                            ? investNewStore.pendingValue
                            : investStore.getPendingPriceBySymbol(instrument.symbol ?? ''),
                        amount: investNewStore.amountValue,
                        limits: investNewStore.isSLTPPrice
                            ? instrument.takeProfitPriceLimits!
                            : instrument.takeProfitAmountLimits!,
                        isAmount: !investNewStore.isSLTPPrice,
                        isSl: false,
                      )[4],
                      minValue: calculateLimitsPositions(
                        price: investNewStore.isOrderMode
                            ? investNewStore.pendingValue
                            : investStore.getPendingPriceBySymbol(instrument.symbol ?? ''),
                        amount: investNewStore.amountValue,
                        limits: investNewStore.isSLTPPrice
                            ? instrument.takeProfitPriceLimits!
                            : instrument.takeProfitAmountLimits!,
                        isAmount: !investNewStore.isSLTPPrice,
                        isSl: false,
                      )[0],
                      currentValue: investNewStore.isSLTPPrice
                          ? investNewStore.tpPriceValue
                          : investNewStore.tpAmountValue,
                      divisions: 4,
                      withArray: true,
                      fullScale: !investNewStore.isSLTPPrice,
                      arrayOfValues: calculateLimitsPositions(
                        price: investNewStore.isOrderMode
                            ? investNewStore.pendingValue
                            : investStore.getPendingPriceBySymbol(instrument.symbol ?? ''),
                        amount: investNewStore.amountValue,
                        limits: investNewStore.isSLTPPrice
                            ? instrument.takeProfitPriceLimits!
                            : instrument.takeProfitAmountLimits!,
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
                      },
                      defaultIcon: investNewStore.isSl
                          ? const SICheckedIcon(width: 20, height: 20,)
                          : const SICheckIcon(width: 20, height: 20,),
                      pressedIcon: investNewStore.isSl
                          ? const SICheckedIcon(width: 20, height: 20,)
                          : const SICheckIcon(width: 20, height: 20,),
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
                      style: sBody2InvestMStyle.copyWith(
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
                                style: sBody2InvestMStyle.copyWith(
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
                        child:InvestInput(
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
                  if (
                  instrument.stopLossAmountLimits != null &&
                      instrument.stopLossAmountLimits!.isNotEmpty &&
                      instrument.stopLossPriceLimits != null &&
                      instrument.stopLossPriceLimits!.isNotEmpty
                  ) ...[
                    const SpaceH8(),
                    InvestSliderInput(
                      maxValue: calculateLimitsPositions(
                        price: investNewStore.isOrderMode
                            ? investNewStore.pendingValue
                            : investStore.getPendingPriceBySymbol(instrument.symbol ?? ''),
                        amount: investNewStore.amountValue,
                        limits: investNewStore.isSLTPPrice
                            ? instrument.stopLossPriceLimits!
                            : instrument.stopLossAmountLimits!,
                        isAmount: !investNewStore.isSLTPPrice,
                        isSl: true,
                      )[4].abs(),
                      minValue: calculateLimitsPositions(
                        price: investNewStore.isOrderMode
                            ? investNewStore.pendingValue
                            : investStore.getPendingPriceBySymbol(instrument.symbol ?? ''),
                        amount: investNewStore.amountValue,
                        limits: investNewStore.isSLTPPrice
                            ? instrument.stopLossPriceLimits!
                            : instrument.stopLossAmountLimits!,
                        isAmount: !investNewStore.isSLTPPrice,
                        isSl: true,
                      )[0].abs(),
                      currentValue: investNewStore.isSLTPPrice
                          ? investNewStore.slPriceValue
                          : investNewStore.slAmountValue.abs(),
                      divisions: 4,
                      withArray: true,
                      fullScale: !investNewStore.isSLTPPrice,
                      arrayOfValues: calculateLimitsPositions(
                        price: investNewStore.isOrderMode
                            ? investNewStore.pendingValue
                            : investStore.getPendingPriceBySymbol(instrument.symbol ?? ''),
                        amount: investNewStore.amountValue,
                        limits: investNewStore.isSLTPPrice
                            ? instrument.stopLossPriceLimits!
                            : instrument.stopLossAmountLimits!,
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
        ],
      ),
    );
  }
}
