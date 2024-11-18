import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart' as oldColors;
import 'package:simple_kit_updated/simple_kit_updated.dart';
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
  bool isPendingInvest = false,
}) {
  final investNewStore = getIt.get<InvestNewStore>();
  investNewStore.resetStore();
  investNewStore.setPosition(position);
  investNewStore.setInstrument(instrument);
  investNewStore.setIsBuyMode(position.direction == Direction.buy);
  investNewStore.setIsSLMode(position.stopLossType != TPSLType.undefined);
  investNewStore.setIsTPMode(position.takeProfitType != TPSLType.undefined);
  investNewStore.setIsLimitsVisible(true);
  investNewStore.setIsOrderMode(false, isPending: isPendingInvest);
  investNewStore.setIsSLTPPrice(
    position.stopLossType == TPSLType.price || position.takeProfitType == TPSLType.price,
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

  final colors = oldColors.SColorsLight();

  showBasicBottomSheet(
    context: context,
    button: Material(
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
                          activeColor: oldColors.SColorsLight().gray2,
                          activeNameColor: SColorsLight().black,
                          inactiveColor: oldColors.SColorsLight().gray8,
                          inactiveNameColor: oldColors.SColorsLight().gray4,
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
                          inactiveColor: oldColors.SColorsLight().gray4,
                          inactiveNameColor: oldColors.SColorsLight().gray8,
                          active: true,
                          name: intl.invest_save,
                          onTap: () async {
                            if (position.status == PositionStatus.pending) {
                              await investNewStore.changePendingPrice(
                                id: position.id!,
                                price: double.parse(
                                  investNewStore.pendingPriceController.text,
                                ),
                              );
                            }
                            Future.delayed(
                              const Duration(milliseconds: 500),
                              onSecondaryButtonTap.call,
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
    children: [
      if (isPendingInvest) ...[
        SPaddingH24(
          child: Text(
            intl.invest_pending_price,
            style: STStyles.body2InvestM.copyWith(
              color: colors.black,
            ),
          ),
        ),
        const SpaceH4(),
        SPaddingH24(
          child: Observer(
            builder: (context) {
              return InvestInput(
                onChanged: investNewStore.onPendingInput,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp('[0-9,.]')),
                ],
                controller: investNewStore.pendingPriceController,
                keyboardType: TextInputType.number,
              );
            },
          ),
        ),
        const SpaceH12(),
      ],
      InfoBlock(
        instrument: instrument,
        position: position,
      ),
    ],
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

    final colors = oldColors.SColorsLight();
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
                  style: STStyles.body1InvestSM.copyWith(
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
                      activeTab: investNewStore.isSLTPPrice ? 1 : 0,
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
                    SafeGesture(
                      onTap: () {
                        investNewStore.setIsTPMode(!investNewStore.isTP);
                      },
                      child: investNewStore.isTP
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
                        enabled: !investNewStore.isSLTPPrice && investNewStore.isTP,
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
                        enabled: investNewStore.isSLTPPrice && investNewStore.isTP,
                      ),
                    ),
                  ],
                ),
                if (instrument.takeProfitAmountLimits != null &&
                    instrument.takeProfitAmountLimits!.isNotEmpty &&
                    instrument.takeProfitPriceLimits != null &&
                    instrument.takeProfitPriceLimits!.isNotEmpty) ...[
                  const SpaceH8(),
                  InvestSliderInput(
                    isDisabled: !investNewStore.isTP,
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
                    currentValue:
                        investNewStore.isSLTPPrice ? investNewStore.tpPriceValue : investNewStore.tpAmountValue,
                    divisions: 4,
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
                Row(
                  children: [
                    SafeGesture(
                      onTap: () {
                        investNewStore.setIsSLMode(!investNewStore.isSl);
                      },
                      child: investNewStore.isSl
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
                        enabled: !investNewStore.isSLTPPrice && investNewStore.isSl,
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
                        enabled: investNewStore.isSLTPPrice && investNewStore.isSl,
                      ),
                    ),
                  ],
                ),
                if (instrument.stopLossAmountLimits != null &&
                    instrument.stopLossAmountLimits!.isNotEmpty &&
                    instrument.stopLossPriceLimits != null &&
                    instrument.stopLossPriceLimits!.isNotEmpty) ...[
                  const SpaceH8(),
                  InvestSliderInput(
                    isDisabled: !investNewStore.isSl,
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
                    )[4]
                        .abs(),
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
                    )[0]
                        .abs(),
                    currentValue:
                        investNewStore.isSLTPPrice ? investNewStore.slPriceValue : investNewStore.slAmountValue.abs(),
                    divisions: 4,
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
              ],
            ),
          ],
        ],
      ),
    );
  }
}
