import 'dart:async';
import 'package:charts/main.dart';
import 'package:charts/simple_chart.dart';
import 'package:charts/utils/data_feed_util.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/services/local_cache/local_cache_service.dart';
import 'package:jetwallet/features/chart/helper/format_merge_candles_count.dart';
import 'package:jetwallet/features/chart/helper/format_resolution.dart';
import 'package:jetwallet/features/chart/model/chart_union.dart';
import 'package:jetwallet/features/invest/ui/invests/data_line.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/modules/candles_api/models/candles_request_model.dart';

import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';

import '../../../../core/di/di.dart';
import '../../../../core/l10n/i10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/simple_networking/simple_networking.dart';
import '../../../../utils/formatting/base/volume_format.dart';
import '../../ui/widgets/invest_alert_bottom_sheet.dart';
import 'invest_dashboard_store.dart';

part 'invest_new_store.g.dart';

@lazySingleton
class InvestNewStore = _InvestNewStoreBase with _$InvestNewStore;

abstract class _InvestNewStoreBase with Store {
  _InvestNewStoreBase() {
    loader = StackLoaderStore();
  }

  @observable
  StackLoaderStore? loader;

  @observable
  InvestInstrumentModel? instrument;
  @action
  void setInstrument(InvestInstrumentModel value) {
    instrument = value;
  }

  @observable
  bool canClick = true;
  @action
  void setCanClick(bool value) {
    canClick = value;
  }

  @observable
  int chartInterval = 0;
  @action
  void setChartInterval(int value) {
    chartInterval = value;
  }

  @observable
  int chartType = 0;
  @action
  void setChartType(int value) {
    chartType = value;
  }

  @observable
  InvestPositionModel? position;
  @action
  void setPosition(InvestPositionModel value) {
    position = value;
  }

  @observable
  TextEditingController amountController = TextEditingController();
  @observable
  Decimal amountValue = Decimal.zero;
  @action
  void onAmountInput(String newValue) {
    amountValue = Decimal.fromJson(newValue);
    amountController.text = '${Decimal.fromJson(newValue)}';
    if (isSLTPPrice) {
      updateSlAmount();
      updateTPAmount();
    } else {
      updateSlPrice();
      updateTPPrice();
    }
  }

  @observable
  int multiplicator = 1;
  @action
  void setMultiplicator(int newValue) {
    multiplicator = newValue;
    if (isSLTPPrice) {
      updateSlAmount();
      updateTPAmount();
    } else {
      updateSlPrice();
      updateTPPrice();
    }
  }

  @observable
  TextEditingController pendingPriceController = TextEditingController();
  @observable
  Decimal pendingValue = Decimal.zero;
  @action
  void onPendingInput(String newValue) {
    pendingValue = Decimal.fromJson(newValue);

    if (isSLTPPrice) {
      updateSlAmount();
      updateTPAmount();
    } else {
      updateSlPrice();
      updateTPPrice();
    }
  }

  @observable
  TextEditingController tpAmountController = TextEditingController();
  @observable
  Decimal tpAmountValue = Decimal.zero;
  @action
  void onTPAmountInput(String newValue) {
    tpAmountValue = Decimal.fromJson(newValue);
    tpAmountController.text = '${Decimal.fromJson(newValue)}';
    updateTPPrice();
  }

  @action
  void updateTPPrice() {
    final investStore = getIt.get<InvestDashboardStore>();
    final marketPrice = isOrderMode ? pendingValue : investStore.getPendingPriceBySymbol(instrument?.symbol ?? '');
    final investPositionTakeProfitAmount = tpAmountValue;
    final volume = amountValue * Decimal.fromInt(multiplicator);
    final openFee = volume * (instrument?.openFee ?? Decimal.zero);
    final closeFee = (volume + investPositionTakeProfitAmount) *
        Decimal.fromInt(multiplicator) *
        (instrument?.closeFee ?? Decimal.zero);
    tpPriceValue = isBuyMode
        ? marketPrice *
            (Decimal.one +
                Decimal.fromJson('${(investPositionTakeProfitAmount / volume).toDouble()}') +
                Decimal.fromJson('${((openFee + closeFee) / volume).toDouble()}'))
        : marketPrice *
            (Decimal.one -
                Decimal.fromJson('${(investPositionTakeProfitAmount / volume).toDouble()}') -
                Decimal.fromJson('${((openFee + closeFee) / volume).toDouble()}'));
    tpPriceController.text = 'est. ${volumeFormat(
      decimal: tpPriceValue,
      symbol: '',
      accuracy: instrument?.priceAccuracy ?? 2,
    )}';
  }

  @action
  void updateTPAmount() {
    final investStore = getIt.get<InvestDashboardStore>();
    final marketPrice = isOrderMode ? pendingValue : investStore.getPendingPriceBySymbol(instrument?.symbol ?? '');

    final investPositionTakeProfitPrice = tpPriceValue;
    final volume = amountValue * Decimal.fromInt(multiplicator);
    final volumeBase = Decimal.fromJson('${(volume / marketPrice).toDouble()}');
    final openFee = volume * (instrument?.openFee ?? Decimal.zero);
    final closeFee = volumeBase * investPositionTakeProfitPrice * (instrument?.closeFee ?? Decimal.zero);
    tpAmountValue = isBuyMode
        ? (investPositionTakeProfitPrice - marketPrice) * volumeBase - openFee - closeFee
        : -(investPositionTakeProfitPrice - marketPrice) * volumeBase - openFee - closeFee;
    tpAmountController.text = 'est. ${volumeFormat(
      decimal: tpAmountValue,
      symbol: '',
      accuracy: 2,
    )}';
  }

  @action
  void updateSlPrice() {
    final investStore = getIt.get<InvestDashboardStore>();
    final marketPrice = isOrderMode ? pendingValue : investStore.getPendingPriceBySymbol(instrument?.symbol ?? '');
    final investPositionStopLossAmount = slAmountValue;
    final volume = amountValue * Decimal.fromInt(multiplicator);
    final openFee = volume * (instrument?.openFee ?? Decimal.zero);
    final closeFee = (volume + investPositionStopLossAmount) *
        Decimal.fromInt(multiplicator) *
        (instrument?.closeFee ?? Decimal.zero);
    slPriceValue = isBuyMode
        ? marketPrice *
            (Decimal.one +
                Decimal.fromJson('${(investPositionStopLossAmount / volume).toDouble()}') +
                Decimal.fromJson('${((openFee + closeFee) / volume).toDouble()}'))
        : marketPrice *
            (Decimal.one -
                Decimal.fromJson('${(investPositionStopLossAmount / volume).toDouble()}') -
                Decimal.fromJson('${((openFee + closeFee) / volume).toDouble()}'));
    slPriceController.text = 'est. ${volumeFormat(
      decimal: slPriceValue,
      symbol: '',
      accuracy: instrument?.priceAccuracy ?? 2,
    )}';
  }

  @action
  void updateSlAmount() {
    final investStore = getIt.get<InvestDashboardStore>();
    final marketPrice = isOrderMode ? pendingValue : investStore.getPendingPriceBySymbol(instrument?.symbol ?? '');
    final investPositionStopLossPrice = slPriceValue;
    final volume = amountValue * Decimal.fromInt(multiplicator);
    final volumeBase = Decimal.fromJson('${(volume / marketPrice).toDouble()}');
    final openFee = volume * (instrument?.openFee ?? Decimal.zero);
    final closeFee = volumeBase * investPositionStopLossPrice * (instrument?.closeFee ?? Decimal.zero);
    slAmountValue = isBuyMode
        ? (investPositionStopLossPrice - marketPrice) * volumeBase - openFee - closeFee
        : -(investPositionStopLossPrice - marketPrice) * volumeBase - openFee - closeFee;
    slAmountController.text = 'est. ${volumeFormat(
      decimal: slAmountValue,
      symbol: '',
      accuracy: 2,
    )}';
  }

  @observable
  TextEditingController tpPriceController = TextEditingController();
  @observable
  Decimal tpPriceValue = Decimal.zero;
  @action
  void onTPPriceInput(String newValue) {
    tpPriceValue = Decimal.fromJson(newValue);
    tpPriceController.text = '${Decimal.fromJson(newValue)}';
    updateTPAmount();
  }

  @observable
  TextEditingController slAmountController = TextEditingController();
  @observable
  Decimal slAmountValue = Decimal.zero;
  @action
  void onSLAmountInput(String newValue) {
    slAmountValue = -Decimal.fromJson(newValue).abs();
    slAmountController.text = '${-Decimal.fromJson(newValue).abs()}';
    updateSlPrice();
  }

  @observable
  TextEditingController slPriceController = TextEditingController();
  @observable
  Decimal slPriceValue = Decimal.zero;
  @action
  void onSLPriceInput(String newValue) {
    slPriceValue = Decimal.fromJson(newValue);
    slPriceController.text = '${Decimal.fromJson(newValue)}';
    updateSlAmount();
  }

  @observable
  bool isBuyMode = true;
  @action
  void setIsBuyMode(bool newValue) {
    isBuyMode = newValue;
    tpAmountController.text = '0';
    tpPriceController.text = '0';
    slAmountController.text = '0';
    slPriceController.text = '0';
    tpPriceValue = Decimal.zero;
    tpAmountValue = Decimal.zero;
    slPriceValue = Decimal.zero;
    slAmountValue = Decimal.zero;
    isSLTPPrice = false;
    isSl = false;
    isTP = false;
    isLimitsVisible = false;
  }

  @observable
  bool isSl = false;
  @action
  void setIsSLMode(bool newValue) {
    isSl = newValue;
  }

  @observable
  bool isTP = false;
  @action
  void setIsTPMode(bool newValue) {
    isTP = newValue;
  }

  @observable
  bool isSLTPPrice = false;
  @action
  void setIsSLTPPrice(bool newValue) {
    isSLTPPrice = newValue;
    if (newValue) {
      slAmountController.text = 'est. ${volumeFormat(
        decimal: slAmountValue,
        symbol: '',
        accuracy: 2,
      )}';
      tpAmountController.text = 'est. ${volumeFormat(
        decimal: tpAmountValue,
        symbol: '',
        accuracy: 2,
      )}';
      slPriceController.text = volumeFormat(
        decimal: slPriceValue,
        symbol: '',
        accuracy: instrument?.priceAccuracy ?? 2,
      ).replaceAll(' ', '');
      tpPriceController.text = volumeFormat(
        decimal: tpPriceValue,
        symbol: '',
        accuracy: instrument?.priceAccuracy ?? 2,
      ).replaceAll(' ', '');
    } else {
      slPriceController.text = 'est. ${volumeFormat(
        decimal: slPriceValue,
        symbol: '',
        accuracy: instrument?.priceAccuracy ?? 2,
      )}';
      tpPriceController.text = 'est. ${volumeFormat(
        decimal: tpPriceValue,
        symbol: '',
        accuracy: instrument?.priceAccuracy ?? 2,
      )}';
      slAmountController.text = volumeFormat(
        decimal: slAmountValue,
        symbol: '',
        accuracy: 2,
      ).replaceAll(' ', '');
      tpAmountController.text = volumeFormat(
        decimal: tpAmountValue,
        symbol: '',
        accuracy: 2,
      ).replaceAll(' ', '');
    }
  }

  @observable
  bool isLimitsVisible = false;
  @action
  void setIsLimitsVisible(bool newValue) {
    isLimitsVisible = newValue;
  }

  @observable
  bool isOrderMode = false;
  @action
  void setIsOrderMode(bool newValue) {
    isOrderMode = newValue;
    final investStore = getIt.get<InvestDashboardStore>();
    final marketPrice = investStore.getPendingPriceBySymbol(instrument?.symbol ?? '');
    pendingPriceController.text = '$marketPrice';
    pendingValue = marketPrice;
  }

  @action
  Future<void> createPosition() async {
    loader?.startLoading();

    if (!isOrderMode) {
      final model = NewInvestRequestModel(
        symbol: instrument?.symbol ?? '',
        amount: amountValue,
        amountAssetId: 'USDT',
        multiplicator: multiplicator,
        direction: isBuyMode ? Direction.buy : Direction.sell,
        takeProfitType: isLimitsVisible
            ? isSLTPPrice
                ? TPSLType.price
                : TPSLType.amount
            : TPSLType.undefined,
        takeProfitValue: isLimitsVisible
            ? isSLTPPrice
                ? tpPriceValue
                : tpAmountValue
            : Decimal.zero,
        stopLossType: isLimitsVisible
            ? isSLTPPrice
                ? TPSLType.price
                : TPSLType.amount
            : TPSLType.undefined,
        stopLossValue: isLimitsVisible
            ? isSLTPPrice
                ? slPriceValue
                : slAmountValue.abs()
            : Decimal.zero,
      );
      await createActivePosition(model);
    } else {
      final model = NewInvestOrderRequestModel(
        symbol: instrument?.symbol ?? '',
        amount: amountValue,
        amountAssetId: 'USDT',
        multiplicator: multiplicator,
        direction: isBuyMode ? Direction.buy : Direction.sell,
        takeProfitType: isLimitsVisible
            ? isSLTPPrice
                ? TPSLType.price
                : TPSLType.amount
            : TPSLType.undefined,
        takeProfitValue: isLimitsVisible
            ? isSLTPPrice
                ? tpPriceValue
                : tpAmountValue
            : Decimal.zero,
        stopLossType: isLimitsVisible
            ? isSLTPPrice
                ? TPSLType.price
                : TPSLType.amount
            : TPSLType.undefined,
        stopLossValue: isLimitsVisible
            ? isSLTPPrice
                ? slPriceValue
                : slAmountValue.abs()
            : Decimal.zero,
        targetPrice: pendingValue,
      );
      final investStore = getIt.get<InvestDashboardStore>();
      final marketPrice = investStore.getPendingPriceBySymbol(instrument?.symbol ?? '');
      if ((isBuyMode && pendingValue > marketPrice) || (!isBuyMode && pendingValue < marketPrice)) {
        await createPendingStopPosition(model);
      } else {
        await createPendingLimitPosition(model);
      }
    }
  }

  @action
  Future<void> createActivePosition(NewInvestRequestModel model) async {
    if (!hasActiveError()) {
      try {
        final response = await getIt.get<SNetwork>().simpleNetworking.getWalletModule().createActivePosition(model);

        if (response.hasError) {
          sNotification.showError(
            response.error?.cause ?? '',
            id: 1,
            needFeedback: true,
          );
          loader!.finishLoading();
        } else {
          await checkNewPosition(
            response.data?.position?.id ?? '',
          );
        }
      } catch (e) {
        sNotification.showError(
          intl.something_went_wrong,
        );
        loader!.finishLoading();
      }
    } else {
      loader!.finishLoading();
    }
  }

  @action
  Future<void> createPendingLimitPosition(NewInvestOrderRequestModel model) async {
    if (!hasPendingError()) {
      try {
        final response =
            await getIt.get<SNetwork>().simpleNetworking.getWalletModule().createPendingLimitPosition(model);
        loader!.finishLoading();
        if (response.hasError) {
          sNotification.showError(
            response.error?.cause ?? '',
            id: 1,
            needFeedback: true,
          );
        } else {
          final context = sRouter.navigatorKey.currentContext!;
          final volume = amountValue * Decimal.fromInt(multiplicator);
          final openFee = volume * (instrument?.openFee ?? Decimal.zero);

          showInvestInfoBottomSheet(
            context: context,
            type: 'success',
            onPrimaryButtonTap: () {
              resetStore();
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            primaryButtonName: intl.invest_alert_got_it,
            bottomWidget: Column(
              children: [
                DataLine(
                  mainText: intl.invest_amount,
                  secondaryText: volumeFormat(
                    decimal: model.amount,
                    symbol: 'USDT',
                    accuracy: 2,
                  ),
                ),
                const SpaceH8(),
                DataLine(
                  mainText: intl.invest_multiplicator,
                  secondaryText: 'x${model.multiplicator}',
                ),
                const SpaceH8(),
                DataLine(
                  mainText: intl.invest_trigger_price,
                  secondaryText: volumeFormat(
                    decimal: model.targetPrice,
                    symbol: 'USDT',
                    accuracy: 2,
                  ),
                ),
                const SpaceH16(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DataLine(
                      fullWidth: false,
                      mainText: intl.invest_open_fee,
                      secondaryText: volumeFormat(
                        decimal: openFee,
                        symbol: 'USDT',
                        accuracy: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            title: intl.invest_pending_placed,
          );
        }
      } catch (e) {
        sNotification.showError(
          intl.something_went_wrong,
        );
        loader?.finishLoading();
      }
    } else {
      loader!.finishLoading();
    }
  }

  @action
  Future<void> createPendingStopPosition(NewInvestOrderRequestModel model) async {
    if (!hasPendingError()) {
      try {
        final response =
            await getIt.get<SNetwork>().simpleNetworking.getWalletModule().createPendingStopPosition(model);
        loader!.finishLoading();
        if (response.hasError) {
          sNotification.showError(
            response.error?.cause ?? '',
            id: 1,
            needFeedback: true,
          );
        } else {
          final context = sRouter.navigatorKey.currentContext!;
          final volume = amountValue * Decimal.fromInt(multiplicator);
          final openFee = volume * (instrument?.openFee ?? Decimal.zero);

          showInvestInfoBottomSheet(
            context: context,
            type: 'success',
            onPrimaryButtonTap: () {
              resetStore();
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            primaryButtonName: intl.invest_alert_got_it,
            bottomWidget: Column(
              children: [
                DataLine(
                  mainText: intl.invest_amount,
                  secondaryText: volumeFormat(
                    decimal: model.amount,
                    symbol: 'USDT',
                    accuracy: 2,
                  ),
                ),
                const SpaceH8(),
                DataLine(
                  mainText: intl.invest_multiplicator,
                  secondaryText: 'x${model.multiplicator}',
                ),
                const SpaceH8(),
                DataLine(
                  mainText: intl.invest_trigger_price,
                  secondaryText: volumeFormat(
                    decimal: model.targetPrice,
                    symbol: 'USDT',
                    accuracy: 2,
                  ),
                ),
                const SpaceH16(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DataLine(
                      fullWidth: false,
                      mainText: intl.invest_open_fee,
                      secondaryText: volumeFormat(
                        decimal: openFee,
                        symbol: 'USDT',
                        accuracy: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            title: intl.invest_pending_placed,
          );
        }
      } catch (e) {
        sNotification.showError(
          intl.something_went_wrong,
        );
        loader!.finishLoading();
      }
    } else {
      loader!.finishLoading();
    }
  }

  @action
  Future<void> checkNewPosition(String id) async {
    try {
      final response = await getIt.get<SNetwork>().simpleNetworking.getWalletModule().getPosition(positionId: id);

      if (response.hasError) {
        sNotification.showError(
          response.error?.cause ?? '',
          id: 1,
          needFeedback: true,
        );
        loader!.finishLoading();
      } else {
        if (response.data?.position?.status == PositionStatus.opening) {
          Timer(
            const Duration(seconds: 1),
            () {
              checkNewPosition(id);
            },
          );
        } else {
          loader!.finishLoading();
          if (!isOrderMode) {
            final context = sRouter.navigatorKey.currentContext!;
            final investStore = getIt.get<InvestDashboardStore>();
            final marketPrice = investStore.getPendingPriceBySymbol(instrument?.symbol ?? '');
            showInvestInfoBottomSheet(
              context: context,
              type: 'success',
              onPrimaryButtonTap: () {
                resetStore();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                sRouter.push(
                  ActiveInvestManageRouter(instrument: instrument!, position: response.data!.position!),
                );
              },
              primaryButtonName: intl.invest_alert_got_it,
              removeWidgetSpace: true,
              bottomWidget: Column(
                children: [
                  const SpaceH16(),
                  DataLine(
                    mainText: intl.invest_amount,
                    secondaryText: volumeFormat(
                      decimal: response.data!.position!.amount!,
                      symbol: 'USDT',
                      accuracy: 2,
                    ),
                  ),
                  const SpaceH8(),
                  DataLine(
                    mainText: intl.invest_multiplicator,
                    secondaryText: 'x${response.data!.position!.multiplicator}',
                  ),
                  const SpaceH8(),
                  DataLine(
                    mainText: intl.invest_open_price,
                    secondaryText: volumeFormat(
                      decimal: marketPrice,
                      symbol: 'USDT',
                      accuracy: 2,
                    ),
                  ),
                  const SpaceH22(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DataLine(
                        fullWidth: false,
                        mainText: intl.invest_open_fee,
                        secondaryText: volumeFormat(
                          decimal: response.data!.position?.openFee ?? Decimal.zero,
                          symbol: 'USDT',
                          accuracy: 2,
                        ),
                      ),
                    ],
                  ),
                  const SpaceH6(),
                ],
              ),
              title: intl.invest_success_opened,
            );
          }
        }
      }
    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong,
      );
      loader!.finishLoading();
    }
  }

  @action
  Future<void> saveLimits(String id) async {
    loader!.startLoading();
    if (!hasActiveError()) {
      try {
        final model = TPSLPositionModel(
          positionId: id,
          takeProfitType: isTP
              ? isSLTPPrice
                  ? TPSLType.price
                  : TPSLType.amount
              : TPSLType.undefined,
          takeProfitValue: isTP
              ? isSLTPPrice
                  ? tpPriceValue
                  : tpAmountValue
              : Decimal.zero,
          stopLossType: isSl
              ? isSLTPPrice
                  ? TPSLType.price
                  : TPSLType.amount
              : TPSLType.undefined,
          stopLossValue: isSl
              ? isSLTPPrice
                  ? slPriceValue
                  : slAmountValue.abs()
              : Decimal.zero,
        );

        final response = await getIt.get<SNetwork>().simpleNetworking.getWalletModule().setPositionTPSL(data: model);
        loader!.finishLoading();

        if (response.hasError) {
          sNotification.showError(
            response.error?.cause ?? '',
            id: 1,
            needFeedback: true,
          );
          loader!.finishLoading();
        } else {
          setPosition(response.data!.position!);
          Navigator.pop(sRouter.navigatorKey.currentContext!);
          showInvestInfoBottomSheet(
            context: sRouter.navigatorKey.currentContext!,
            type: 'success',
            onPrimaryButtonTap: () {
              Navigator.pop(sRouter.navigatorKey.currentContext!);
            },
            primaryButtonName: intl.invest_alert_got_it,
            bottomWidget: Column(
              children: [
                if (response.data!.position!.takeProfitType != TPSLType.undefined) ...[
                  DataLine(
                    withDot: true,
                    dotColor: SColorsLight().green,
                    mainText: intl.invest_limits_take_profit,
                    secondaryText: response.data!.position!.takeProfitType == TPSLType.amount
                        ? volumeFormat(
                            decimal: response.data!.position!.takeProfitAmount ?? Decimal.zero,
                            accuracy: 2,
                            symbol: 'USDT',
                          )
                        : volumeFormat(
                            decimal: response.data!.position!.takeProfitPrice ?? Decimal.zero,
                            accuracy: instrument?.priceAccuracy ?? 2,
                            symbol: '',
                          ),
                  ),
                ],
                if (response.data!.position!.stopLossType != TPSLType.undefined) ...[
                  if (response.data!.position!.takeProfitType != TPSLType.undefined) const SpaceH8(),
                  DataLine(
                    withDot: true,
                    dotColor: SColorsLight().red,
                    mainText: intl.invest_limits_stop_loss,
                    secondaryText: response.data!.position!.stopLossType == TPSLType.amount
                        ? volumeFormat(
                            decimal: response.data!.position!.stopLossAmount ?? Decimal.zero,
                            accuracy: 2,
                            symbol: 'USDT',
                          )
                        : volumeFormat(
                            decimal: response.data!.position!.stopLossPrice ?? Decimal.zero,
                            accuracy: instrument?.priceAccuracy ?? 2,
                            symbol: '',
                          ),
                  ),
                ],
              ],
            ),
            title: intl.invest_success_saved_limits,
          );
        }
      } catch (e) {
        sNotification.showError(
          intl.something_went_wrong,
        );
        loader!.finishLoading();
      }
    } else {
      loader!.finishLoading();
    }
  }

  @action
  bool hasActiveError() {
    if (instrument == null) {
      return true;
    } else {
      final investStore = getIt.get<InvestDashboardStore>();
      final marketPrice = investStore.getPendingPriceBySymbol(instrument?.symbol ?? '');
      final minPriceMarket = (Decimal.fromInt(1) - instrument!.pendingPriceRestrictions!) * marketPrice;
      final maxPriceMarket = (Decimal.fromInt(1) + instrument!.pendingPriceRestrictions!) * marketPrice;

      if (amountValue * Decimal.fromInt(multiplicator) > instrument!.maxVolume!) {
        sNotification.showError(
          '${intl.invest_error_amount_higher}${instrument!.maxVolume!}',
          id: 1,
          needFeedback: true,
        );

        return true;
      }
      if (amountValue * Decimal.fromInt(multiplicator) < instrument!.minVolume!) {
        sNotification.showError(
          '${intl.invest_error_amount_lower}${instrument!.minVolume!}',
          id: 1,
          needFeedback: true,
        );

        return true;
      }
      if (isLimitsVisible) {
        if (isBuyMode) {
          if (tpPriceValue > maxPriceMarket && isTP) {
            sNotification.showError(
              '${intl.invest_error_tp_higher}$maxPriceMarket',
              id: 1,
              needFeedback: true,
            );

            return true;
          }
          if (tpPriceValue <= marketPrice && isTP) {
            sNotification.showError(
              '${intl.invest_error_tp_lower}$marketPrice',
              id: 1,
              needFeedback: true,
            );

            return true;
          }
          if (slPriceValue >= marketPrice && isSl) {
            sNotification.showError(
              '${intl.invest_error_sl_higher}$marketPrice',
              id: 1,
              needFeedback: true,
            );

            return true;
          }
        } else {
          if (tpPriceValue < minPriceMarket && isTP) {
            sNotification.showError(
              '${intl.invest_error_tp_lower}$minPriceMarket',
              id: 1,
              needFeedback: true,
            );

            return true;
          }
          if (tpPriceValue >= marketPrice && isTP) {
            sNotification.showError(
              '${intl.invest_error_tp_higher}$marketPrice',
              id: 1,
              needFeedback: true,
            );

            return true;
          }
          if (slPriceValue <= marketPrice && isSl) {
            sNotification.showError(
              '${intl.invest_error_sl_lower}$marketPrice',
              id: 1,
              needFeedback: true,
            );

            return true;
          }
        }
        if (isSl && slAmountValue.abs() > amountValue) {
          sNotification.showError(
            '${intl.invest_error_sl_lower}-$amountValue',
            id: 1,
            needFeedback: true,
          );

          return true;
        }
      }
    }

    return false;
  }

  @action
  bool hasPendingPriceError() {
    final investStore = getIt.get<InvestDashboardStore>();
    final marketPrice = investStore.getPendingPriceBySymbol(instrument?.symbol ?? '');

    final minPriceMarket = (Decimal.fromInt(1) - instrument!.pendingPriceRestrictions!) * marketPrice;
    final maxPriceMarket = (Decimal.fromInt(1) + instrument!.pendingPriceRestrictions!) * marketPrice;

    final newPendingValue = pendingValue == Decimal.zero ? marketPrice : pendingValue;

    if (newPendingValue < minPriceMarket) {
      sNotification.showError(
        '${intl.invest_error_pending_price} $minPriceMarket - $maxPriceMarket',
        id: 1,
        needFeedback: true,
      );
      return true;
    } else if (newPendingValue > maxPriceMarket) {
      sNotification.showError(
        '${intl.invest_error_pending_price} $minPriceMarket - $maxPriceMarket',
        id: 1,
        needFeedback: true,
      );
      return true;
    }
    return false;
  }

  @action
  bool hasPendingError() {
    if (instrument == null) {
      return true;
    } else {
      final marketPrice = pendingValue;

      final minPriceMarket = (Decimal.fromInt(1) - instrument!.pendingPriceRestrictions!) * pendingValue;
      final maxPriceMarket = (Decimal.fromInt(1) + instrument!.pendingPriceRestrictions!) * pendingValue;

      if (amountValue > instrument!.maxVolume!) {
        sNotification.showError(
          '${intl.invest_error_amount_higher}${instrument!.maxVolume!}',
          id: 1,
          needFeedback: true,
        );

        return true;
      }
      if (amountValue < instrument!.minVolume!) {
        sNotification.showError(
          '${intl.invest_error_amount_lower}${instrument!.minVolume!}',
          id: 1,
          needFeedback: true,
        );

        return true;
      }
      if (isLimitsVisible) {
        if (isBuyMode) {
          if (tpPriceValue > maxPriceMarket && isTP) {
            sNotification.showError(
              '${intl.invest_error_tp_higher}$maxPriceMarket',
              id: 1,
              needFeedback: true,
            );

            return true;
          }
          if (tpPriceValue <= marketPrice && isTP) {
            sNotification.showError(
              '${intl.invest_error_tp_lower}$marketPrice',
              id: 1,
              needFeedback: true,
            );

            return true;
          }
          if (slPriceValue >= marketPrice && isSl) {
            sNotification.showError(
              '${intl.invest_error_sl_higher}$marketPrice',
              id: 1,
              needFeedback: true,
            );

            return true;
          }
        } else {
          if (tpPriceValue < minPriceMarket && isTP) {
            sNotification.showError(
              '${intl.invest_error_tp_lower}$minPriceMarket',
              id: 1,
              needFeedback: true,
            );

            return true;
          }
          if (tpPriceValue >= marketPrice && isTP) {
            sNotification.showError(
              '${intl.invest_error_tp_higher}$marketPrice',
              id: 1,
              needFeedback: true,
            );

            return true;
          }
          if (slPriceValue <= marketPrice && isSl) {
            sNotification.showError(
              '${intl.invest_error_sl_lower}$marketPrice',
              id: 1,
              needFeedback: true,
            );

            return true;
          }
        }
      }
    }

    return false;
  }

  @action
  String getChartInterval() {
    const intervals = ['15', '60', '240', 'D'];

    return intervals[chartInterval];
  }

  @action
  String getChartType() {
    const intervals = ['3', '1'];

    return intervals[chartType];
  }

  @action
  void resetStore() {
    amountController.text = '10';
    pendingPriceController.text = '0';
    tpAmountController.text = '0';
    tpPriceController.text = '0';
    slAmountController.text = '0';
    slPriceController.text = '0';
    amountValue = Decimal.ten;
    pendingValue = Decimal.zero;
    tpPriceValue = Decimal.zero;
    tpAmountValue = Decimal.zero;
    slPriceValue = Decimal.zero;
    slAmountValue = Decimal.zero;
    isSLTPPrice = false;
    isBuyMode = true;
    isSl = false;
    isTP = false;
    isLimitsVisible = false;
    isOrderMode = false;
    resolution = Period.day;
    candlesList.clear();
  }

  @observable
  String resolution = Period.day;

  @observable
  ChartUnion union = const ChartUnion.loading();

  @observable
  List<CandlesWithIdModel> candlesList = [];

  @action
  Future<void> fetchAssetCandles(String resolution, String instrumentId) async {
    try {
      if (union != const ChartUnion.candles()) {
        union = const ChartUnion.loading();
      }

      await getDataFromCache();

      final toDate = DateTime.now().toUtc();
      final depth = DataFeedUtil.calculateHistoryDepth(resolution);
      final fromDate = toDate.subtract(depth.intervalBackDuration);

      final model = CandlesRequestModel(
        candleId: instrumentId,
        type: timeFrameFrom(resolution),
        bidOrAsk: 0,
        fromDate: fromDate.millisecondsSinceEpoch,
        toDate: toDate.millisecondsSinceEpoch,
        mergeCandlesCount: mergeCandlesCountFrom(resolution),
      );

      final candlesResponse = await sNetwork.getCandlesModule().getCandles(model);

      candlesResponse.pick(
        onData: (candles) {
          final candles1 = candles.candles.map(
            (e) => CandleModel(
              open: e.open,
              close: e.close,
              high: e.high,
              low: e.low,
              date: e.date,
            ),
          );

          updateCandles(candles1.toList(), resolution);
        },
        onError: (e) {
          updateCandles([], resolution);
        },
      );
    } catch (e) {
      updateCandles([], resolution);
    }
  }

  @action
  void updateCandles(List<CandleModel>? newCandles, String resolution) {
    final currentCandles = Map.of(candles);
    currentCandles[resolution] = newCandles;

    candles = currentCandles;
    union = const Candles();

    if (instrument?.symbol != null) {
      getIt<LocalCacheService>().saveChart(
        instrument?.symbol ?? '',
        currentCandles,
      );
    }
  }

  @observable
  Map<String, List<CandleModel>?> candles = {
    Period.day: null,
    Period.week: null,
    Period.month: null,
    Period.year: null,
    Period.all: null,
  };

  @action
  Future<void> updateResolution(
    String newResolution,
    String instrumentSymbol,
  ) async {
    await fetchAssetCandles(
      newResolution,
      instrumentSymbol,
    );
    showAnimation = true;
    resolution = newResolution;
  }

  @action
  Future<void> getDataFromCache() async {
    if (instrument?.symbol != null) {
      final getDataFromCache = await getIt<LocalCacheService>().getChart(instrument?.symbol ?? '');

      if (getDataFromCache != null) {
        candles = getDataFromCache.candle;
        union = const Candles();
      }
    }
  }
}
